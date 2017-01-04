module Model exposing (Image, setOrder, getOrder)


type alias Image =
    { id : String
    , order : Int
    , src : String
    }


setOrder : Int -> Image -> Image
setOrder order image =
    { image | order = order }


getOrder : Image -> Int
getOrder image =
    image.order
