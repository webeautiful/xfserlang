-record(xmlel,
{
    name = <<"">> :: binary(),
    attrs    = [] :: [attr()],
    children = [] :: [xmlel() | cdata()]
}).

-type(cdata() :: {xmlcdata, CData::binary()}).

-type(attr() :: {Name::binary(), Value::binary()}).

-type(xmlel() :: #xmlel{}).
