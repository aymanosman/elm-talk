{-# LANGUAGE OverloadedStrings #-}

module Main where

import Lib
import Web.Scotty

main :: IO ()
main =
  scotty 8080 site
