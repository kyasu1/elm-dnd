module Model exposing (..)


type alias Image =
    { id : String
    , order : Int
    , src : String
    }


setOrder : Int -> Int -> Image -> Image
setOrder left right image =
    if image.order == left then
        { image | order = right }
    else if image.order == right then
        { image | order = left }
    else
        image


getOrder : Maybe Image -> Int
getOrder data =
    case data of
        Just image ->
            image.order

        Nothing ->
            0
