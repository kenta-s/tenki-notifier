{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Main where

import           Data.Aeson
import qualified Data.ByteString.Char8 as S8
import qualified Network.HTTP.Simple   as HS
import           System.Environment    (getEnv)
import           Data.Text
import           GHC.Generics

data WeatherListWrapper = WeatherListWrapper {
  list :: [WeatherList]
} deriving (Generic, Show)
instance FromJSON WeatherListWrapper

data WeatherList = WeatherList {
  weather :: [Weather],
  dt_txt :: Text
} deriving (Generic, Show)
instance FromJSON WeatherList

data Weather = Weather {
  mainInfo :: Text,
  description :: Text
} deriving (Show)
instance FromJSON Weather where
  parseJSON (Object v) = Weather <$> (v .: "main") <*> (v .: "description")

main :: IO ()
main = do
  appId <- getEnv "OPEN_WEATHER_MAP_API_KEY"
  let tokyoId = "1850147"
  req <- HS.parseRequest $ "http://api.openweathermap.org/data/2.5/forecast?id=" ++ tokyoId ++ "&APPID=" ++ appId
  response <- HS.httpJSON req
  let weatherList = (HS.getResponseBody response :: WeatherListWrapper)
  printWeathers $ list weatherList

printWeathers :: [WeatherList] -> IO ()
printWeathers [x] = putStrLn $ printWeather x
printWeathers (x:xs) = do
  putStrLn $ printWeather x
  printWeathers xs

printWeather :: WeatherList -> String
printWeather weatherList =
  "    |  " ++ (unpack weat) ++ appendSpaces ++ "|  " ++ (unpack time) ++ "  |"
  where time = dt_txt weatherList
        weat = mainInfo $ Prelude.head $ weather weatherList
        appendSpaces = Prelude.concat $ Prelude.replicate (8 - Data.Text.length weat) " "
