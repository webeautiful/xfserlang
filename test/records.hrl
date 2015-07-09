-record(xmlel,
{
    name = <<"">> :: binary(),
    attrs    = [] :: [attr()],
    children = [] :: [xmlel() | cdata()]
}).

-type(cdata() :: {xmlcdata, CData::binary()}).

-type(attr() :: {Name::binary(), Value::binary()}).

-type(xmlel() :: #xmlel{}).

-record(muc_registered,
        {us_host = {{<<"">>, <<"">>}, <<"">>} :: {{binary(), binary()}, binary()} | '$1',
         nick = <<"">> :: binary()}).
