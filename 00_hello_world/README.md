```sh
npm install -g elm
elm-package install
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
