module Types exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Url exposing (Url)
import Lamdera

type alias FrontendModel =
    { key : Key, display_counter : Maybe Int 
    }


type alias BackendModel =
    { counter : Int
    }


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
    | NoOpFrontendMsg
    | IncreaseCounter 
    | IncreaseBy5 
    | DecreaseBy5 
    | DecreaseCounter
    | Reset


type ToBackend
    = NoOpToBackend
    | IncreaseBy Int 
    | DecreaseBy Int 



type BackendMsg
    = NoOpBackendMsg 
    | ClientConnected Lamdera.ClientId Lamdera.SessionId
    
    


type ToFrontend
    = NoOpToFrontend
    | CounterUpdated Int 
    | StoredCounterValue Int 