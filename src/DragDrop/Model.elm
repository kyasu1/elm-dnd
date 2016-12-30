module DragDrop.Model exposing (..)


type Msg data
    = DragStart String
    | DragEnter String
    | Drop String
    | DragOver String
    | AddHandler Bool
    | AddTarget (Target data)


type DragState
    = Normal
    | Dragging String


type alias Model data =
    { state : DragState
    , hovering : Maybe String
    , targets : List (Target data)
    }


type alias Target data =
    { id : String
    , data : data
    }


initialModel : List (Target a) -> Model a
initialModel targets =
    Model Normal Nothing targets
