-- |
-- Module      : AOC.Util
-- Copyright   : (c) Justin Le 2018
-- License     : BSD3
--
-- Maintainer  : justin@jle.im
-- Stability   : experimental
-- Portability : non-portable
--
-- Assorted utility functions and orphans used for solutions.
--

module AOC.Util (
    strip
  , eitherToMaybe
  , firstJust
  , maybeToEither
  , maybeAlt
  ) where

import           Control.Applicative
import           Control.Monad.Except
import           Data.Foldable
import qualified Data.Text             as T

-- | Strip trailing and leading whitespace.
strip :: String -> String
strip = T.unpack . T.strip . T.pack

-- | Convert an 'Either' into a 'Maybe', or any 'Alternative' instance,
-- forgetting the error value.
eitherToMaybe :: Alternative m => Either e a -> m a
eitherToMaybe = either (const empty) pure

-- | Convert a 'Maybe' into an 'Either', or any 'MonadError' instance, by
-- providing an error value in case 'Nothing' was given.
maybeToEither :: MonadError e m => e -> Maybe a -> m a
maybeToEither e = maybe (throwError e) pure

-- | Like 'find', but instead of taking an @a -> Bool@, takes an @a ->
-- Maybe b@ and returns the first success.
firstJust
    :: Foldable t
    => (a -> Maybe b)
    -> t a
    -> Maybe b
firstJust p = asum . map p . toList

-- | Generalize a 'Maybe' to any 'Alternative'
maybeAlt :: Alternative m => Maybe a -> m a
maybeAlt = maybe empty pure