// We'll require our CSS file, which doesn't yet exist
require("../css/app.scss");
// And we'll load the phoenix_html javascript from the elixir package
import "../../deps/phoenix_html/priv/static/phoenix_html";

// == POLYFILLS ==
// polyfill es6 promises
require("es6-promise");
// polyfill fetch browser api
require("isomorphic-fetch");
// == END POLYFILLS ==

// == COMPONENTS ==
import Posts from "./components/posts";
import Attachments from "./components/attachments";
// == END COMPONENTS ==

// == USING COMPONENTS ==
// ==== POSTS ====
// Decorate posts
Posts.decorate();
// Preview markdown
Posts.preview();
// Handle attachments for posts
Attachments.mount();
// ==== END POSTS ====
// == END USING COMPONENTS ==
