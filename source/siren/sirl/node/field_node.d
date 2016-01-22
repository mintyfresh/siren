
module siren.sirl.node.field_node;

import std.string;

class FieldNode : Node
{
private:
    string _field;
    string _table;

public:
    this(string table, string field)
    {
        _table = table;
        _field = field;
    }

    @property
    string field()
    {
        return _field;
    }

    @property
    string table()
    {
        return _table;
    }

    override string toString()
    {
        return "Field(%s.%s)".format(_table, _field);
    }
}
