---
layout:     post
published: false
title:      "Limit the exposure of React components"
subtitle:   "Simplify your tests and make project on-boarding a snap"
date:       2016-10-08 12:00:00
author:     "David Ko"
header-img: "img/post-bg-01.jpg"
---

* The problem
  * During the development of a React application, a developer may strive to keep methods short to reduce complexity and cognitive load for other engineers (and their future selves) when viewing the component file.
  * For example, if a `render()` method begins to run too long:
  ```javascript
    // SignUpForm.js

    class SignUpForm extends React.Component {
      constructor(props) {
        super(props);
      }

      render() {
        return (
          <form>
            <h1>2016 Census Sign Up Form</h1>
            <fieldset>
            </fieldset>
          </form>
        );
      }
    }
  ```
* The solution
  * A React component's public methods should only consist of the `render` method and methods having to do with user interaction.
