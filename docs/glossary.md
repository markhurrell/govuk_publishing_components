# Glossary

https://gov-uk.atlassian.net/wiki/spaces/GOVUK/pages/161415270/Key+definitions+-+Publishing+Frontend
https://docs.google.com/document/d/1FLDOdQSPRnvvmshf-1pSiiTx9iccOLR7wxljlq3j8uo/edit?ts=59809d00

## Partial

A partial is a template file included inside another template file, often to avoid repetition of code. Partials tend to be smaller than most other template files and are usually written to work in a specific context with specific data.

A partial:
- can be reused
- won’t work in all scenarios

## Component

A component is an isolated collection of code structured in a specific way that can be reused within or between applications. It is similar in concept to a partial, but considerably more flexible and isolated, and could include its own styles, scripts and tests. Components should be written to a consistent standard, for example in terms of markup structure and class naming.

A component:
- should follow component conventions
- should be isolated from other components
- can be put alongside other components without breaking them
- can be given parameters to control how it behaves
- can be reused

Examples include:
- buttons
- breadcrumbs
- banners/notification messages

## Patterns

From the design team definition: Patterns are an example of good practice. They could be written guidance, design solutions for a specific context (that aren’t delivered as named components), or design templates to make services consistent.

Design team definition: [What is a pattern?](https://docs.google.com/presentation/d/1pqsGwX8Ix4RCcrFMmp5xmosSJR49tkIKzCkEgORV4-g/edit#slide=id.g2400c95dab_0_87)

## Template

A template is a file that defines the structure of a page or part of a page. A partial is a template, and the primary file of a component is a template.

## Isolated

A component is isolated when its styles and scripts have no effect on anything but itself, and it does not rely on anything external to itself to display properly. This means the component will work in any location and will have no ill effect on any page it is placed on. Isolation is achieved through namespacing of CSS and JavaScript.

## Glue code

Glue code is extra code written to allow components to work together. Glue code is generally undesirable in our way of working as it is often varied and undocumented and reduces confidence that a change to a component will not have adverse effects.

Examples include:
- Padding or margin applied to elements that wrap components to provide desired spacing between them.

## Discoverable

Referring to how easy it is to find information about or the existence of an entity such as a component. A component is said to be discoverable if it is clearly documented and such documentation is easy to find.

## Leaky CSS

Leaky CSS is a symptom of code not being isolated, or namespaced correctly. Leaky CSS results in style rules that should be confined to one element or group of elements impacting other, unrelated elements. Leaky CSS is generally undesirable as it can cause unpredictable bugs.

## Different types of testing

Component testing refers to tests carried out on specific components. This allows for specific testing of the workings of the component.
Integration testing refers to tests carried out on a specific page of content, including all of the page elements and components that might be needed to render that content. This testing checks that the content is rendered correctly.
