
module siren.model.base;

import siren.database;
import siren.entity;
import siren.sirl;

import std.conv;
import std.exception;

class Model(E : Entity)
{
private:
    static Adapter _adapter;
    static Query _table;

public:
    @property
    static Adapter adapter()
    {
        if(_adapter is null)
        {
            // Use lazy initialization.
            // TODO : Select adapter based on Entity.
            _adapter = AdapterProvider.get;
        }

        return _adapter;
    }

    private bool create(E entity)
    {
        // TODO : Run callbacks.
        // TODO : Run validations.
        // TODO : Run callbacks.

        auto query = table.insert
            .fields(getNonIDColumnNames!E)
            .values(get(entity, getNonIDColumnFields!E));

        // TODO : Run callbacks.

        auto result = adapter.insert(query, E.stringof);

        // TODO : Run callbacks.

        return true;
    }

    private bool destroy(E entity)
    {
        auto id = get(entity, getIDColumnField!E);

        auto columns = getNonIDColumnNames!E;
        auto values = get(entity, columns);

        auto query = table.destroy
            .where(getIDColumnName!E, id);

        return true;
    }

    static E find(IDType!E id)
    {
        auto query = table.select
            .projection(getColumnNames!E)
            .where(getIDColumnName!E, id)
            .limit(1);

        auto result = adapter.select(query, E.stringof);
        enforce(!result.empty, "No " ~ E.stringof ~ " with id `" ~ id.text ~ "` found.");

        auto entity = new E;
        auto row = result.front;
        set(entity, row.columns, row.toArray);

        return entity;
    }

    @property
    static Query table()
    {
        if(_table is null)
        {
            // Use lazy initialization.
            _table = new Query(getTableName!E);
        }

        return _table;
    }

    private bool update(E entity)
    {
        // TODO : Run callbacks.
        // TODO : Run validations.
        // TODO : Run callbacks.

        auto id = get(entity, getIDColumnField!E);

        auto columns = getNonIDColumnNames!E;
        auto values = get(entity, columns);

        auto query = table.update
            .where(getIDColumnName!E, id)
            .set(columns, values);

        // TODO : Run callbacks.

        auto result = adapter.update(query, E.stringof);

        // TODO : Run callbacks.

        return true;
    }
}
