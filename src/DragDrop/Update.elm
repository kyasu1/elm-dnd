port module DragDrop.Update exposing (..)

import DragDrop.Model exposing (..)


port addEventListener : String -> Cmd msg


initialCmd : List String -> Cmd (Msg a)
initialCmd ids =
    let
        listeners =
            (List.map addEventListener ids)
    in
        Cmd.batch listeners


update : (Maybe a -> Int) -> (Int -> Int -> a -> a) -> Msg a -> Model a -> ( Model a, Cmd (Msg a) )
update getOrder setOrder msg model =
    ( updateModel getOrder setOrder msg model, updateCmd msg model )


swapOrder : (Int -> Int -> a -> a) -> Int -> Int -> Target a -> Target a
swapOrder setOrder left right target =
    { target | data = setOrder left right target.data }


findOrder : (Maybe a -> Int) -> String -> List (Target a) -> Int
findOrder getOrder id targets =
    List.filter (\target -> target.id == id) targets
        |> List.head
        |> Maybe.map .data
        |> getOrder


updateModel : (Maybe a -> Int) -> (Int -> Int -> a -> a) -> Msg a -> Model a -> Model a
updateModel getOrder setOrder msg model =
    case msg of
        DragStart id ->
            { model | state = Dragging id }

        DragEnter id ->
            { model | hovering = Just id }

        DragOver id ->
            model

        Drop droppedId ->
            case model.state of
                Dragging id ->
                    let
                        l =
                            findOrder getOrder id model.targets

                        r =
                            findOrder getOrder droppedId model.targets
                    in
                        { model
                            | state = Normal
                            , hovering = Nothing
                            , targets = List.map (swapOrder setOrder l r) model.targets
                        }

                _ ->
                    model

        AddTarget target ->
            let
                newTargets =
                    List.append model.targets (target :: [])
            in
                { model | targets = newTargets }

        AddHandler _ ->
            model


updateCmd : Msg a -> Model a -> Cmd (Msg a)
updateCmd msg model =
    case msg of
        AddTarget target ->
            addEventListener target.id

        _ ->
            Cmd.none
