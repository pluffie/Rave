module parser.types;

import std.string;
import std.array;
import std.conv : to;
import std.ascii : isAlpha;

enum BasicType {
    Bool,
    //Byte,
    Char,
    Short,
    Int,
    Long,
    Cent,
    Float,
    Double,

    Ushort,
    Uint,
    Ulong,
    Uchar
}



Type getType(string name) {
    switch(name) {
        case "bool": return new TypeBasic("bool");
        case "char": return new TypeBasic("char");
        case "int": return new TypeBasic("int");
        case "short": return new TypeBasic("short");
        case "long": return new TypeBasic("long");
        case "float": return new TypeBasic("float");
        case "double": return new TypeBasic("double");
        case "cent": return new TypeBasic("cent");

        case "ubool": return new TypeBasic("ubool");
        case "uint": return new TypeBasic("uint");
        case "ushort": return new TypeBasic("ushort");
        case "ulong": return new TypeBasic("ulong");
        case "uchar": return new TypeBasic("uchar");

        case "alias": return new TypeAlias();
        default: return new TypeStruct(name);
    }
}

class Type {}

class TypeBasic : Type {
    BasicType type;
    private string value;

    this(string value) {
        this.value = value;
        switch(value) {
            case "int":
                type = BasicType.Int; break;
            case "bool":
                type = BasicType.Bool; break;
            case "short":
                type = BasicType.Short; break;
            case "long":
                type = BasicType.Long; break;
            case "float":
                type = BasicType.Float; break;
            case "double":
                type = BasicType.Double; break;
            case "char":
                type = BasicType.Char; break;
            case "cent":
                type = BasicType.Cent; break;

            case "uint":
                type = BasicType.Uint; break;
            case "ushort":
                type = BasicType.Ushort; break;
            case "ulong":
                type = BasicType.Ulong; break;
            case "uchar":
                type = BasicType.Uchar; break;
            default: break;
        }
    }

    bool isFloat() {
        pragma(inline,true);
        return (type == BasicType.Float || type == BasicType.Double);
    }

    override string toString()
    {
        return this.value;
    }
}

class TypePointer : Type {
    Type instance;

    this(Type instance) {this.instance = instance;}
}

class TypeArray : Type {
    int count;
    Type element;

    this(int count, Type element) {
        this.count = count;
        this.element = element;
    }
}

class TypeAlias : Type {}
class TypeVoid : Type {}
class TypeStruct : Type {
    string name;

    this(string name) {this.name = name;}
}
class TypeFunc : Type {
    Type main;
    Type[] args;

    this(Type main, Type[] args) {
        this.main = main;
        this.args = args;
    }
}