When you are starting out http://elm-lang.org/try is a great place to experiement.

If you want to see what compiling an Elm program looks like then follow the
steps below (you can run the commands in this folder):

```sh
elm-package install evancz/elm-html
```

`elm-package` will ask you to confirm stuff.

```sh
cat > Main.elm
import Html exposing (..)

main =
  text "Hello Elm"
```

`elm-make Main.elm` to build your program. Now open the ouputed `index.html`
file.
