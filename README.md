#box2d-jQuery

This is a custom edit of [franzenzenhofer's box2d-jquery](https://github.com/franzenzenhofer/box2d-jquery) plugin, built modified to suit a particular project and likely unfit for general consumption.

The primary change in this version is the explicit removal of the step where all computed styles are copied to the inline style property of the cloned element. This allows external CSS files to style the cloned elements. This also facilitates easier/faster browser inspection of cloned elements.
