---
title: "Using Ansible to Template Java .properties Files"
description: "I tutorial on how you should be templating out and exposing java .properties file in your ansible roles."
tags:
  - "ansible"
  - "jinja2"
date: 2018-12-31T17:59:13-06:00
draft: false
---

## Introduction
This post should teach you some jinja tricks to make templating out the java .properties file format as painless as possible. For those unfamiliar they generally look something like the following example which was taken from the apache commons config guide. You can find more information and the original [here](https://commons.apache.org/proper/commons-configuration/userguide/howto_properties.html)
```
# Properties definining the GUI
colors.background = #FFFFFF
colors.foreground = #000080

window.width = 500
window.height = 300
```

Notice that they follow a dictionary like structure, if we were to represent
this using yaml it would look something like this.

```yaml
# Properties definining the GUI
colors:
 background: "#FFFFFF"
 foreground: "#000080"

window:
  width: 500
  height: 300
```

If we were to then create a template using the dictionary above to recreate the
properties file originally posted it would look something like this.

```django
# Ansible Managed
colors.background = {{ colors.background }}
colors.foreground = {{ colors.foreground }}

window.width = {{ window.width }}
window.height = {{ window.height }}
```

This is probably the route most people take when templating things out with
ansible and for small files it's perfectly fine. However there are 2 problems
that will creep up when scaling or attempting to use the above solution in a
role and I'm going to show you how to tackle each one.

## The Problems
### Adding Variables
We are going to tackle adding variables first because it makes solving the 2nd
issue a cake walk. You may have noticed already, that **in order to add
variables we will need to update both the template and dictionary above**. In
fact, putting the variables in a dictionary didn't help us save much typing
because we still need to type out the full path in the template.  We can tackle
this problem by updating our template and restructuring our dictionary a
little. Lets first tackle our dictionary, assuming the file we want to template
out if going to be called `usergui.properties` we can structure our new
dictionary like so.

```yaml
usergui_properties:
  colors:
   background: "#FFFFFF"
   foreground: "#000080"
  window:
    width: 500
    height: 300
```

Now lets take a look at the template, we can user some
[jinja2](http://jinja.pocoo.org/) magic to automatically populate both the name
and value based on the dictionary we pass.

```django
{%- macro f(parent, dict) -%}
  {%- for k, v in dict.items() -%}
    {%- if v is mapping -%}
      {%- if parent == "" -%}
        {{ f(k, v) }}
      {%- else -%}
        {{ f(parent + "." + k, v) }}
      {%- endif -%}
    {%- else -%}
      {%- if parent == "" -%}
        {{k}} = {{v}}
      {%- else -%}
        {{parent}}.{{k}} = {{v}}
{% endif -%}
    {%- endif -%}
  {%- endfor -%}
{%- endmacro -%}

{{ f("", usergui_properties) }}
```

Wow! There's a lot going on right there, basically we have defined a recursive
function `f` that we can call to traverse through a dictionary and build us out
a .properties file. The nice thing about this being recursive instead of
iterative is that we can nest dictionaries as deep as we want. Without the need
to add another loop.

If you want to test this out yourself you can create a `vars.yml` file with the
dictionary above along with the template named `usergui.properties.j2` and run
the following command to see the output.

`ansible all -i localhost, -c local -m template -a "src=usergui.properties.j2 dest=./usergui.properties" --extra-vars=@vars.yml`

You can also try adding some variables to the dictionary and see that they are
automatically added to the template. Nice!

You can use the jinja2 snippet above as-is or as a starting point for your own
work.

### Allowing User Overrides

So this is great, we can now allow users to define a dictionary with whatever
structure they want and we can create a properties file though. Suppose we
package this all up in a role but the defaults are usually good enough? The
user of said role will now have to define the entire dictionary just to modify
a single variable. There is an elegant solution to this problem using the jinja
[combine](https://docs.ansible.com/ansible/latest/user_guide/playbooks_filters.html#combining-hashes-dictionaries)
filter. Take a look at our dictionary yet again redefined.

```yaml
usergui_properties:
  colors:
   background: "#000000"
   primary: "#FFFFFF"

default_usergui_properties:
  colors:
   background: "#FFFFFF"
   foreground: "#000080"
  window:
    width: 500
    height: 300
```

We now have 2 dictionaries, a `default_usergui_properties` and a
`usergui_properties`, as you have probably guess the
`default_usergui_properties` contains the defined defaults and the
`usergui_properties` is for our users to override. We can then modify our
template as show below to combine our 2 dictionaries.

```django
{%- macro f(parent, dict) -%}
  {%- for k, v in dict.items() -%}
    {%- if v is mapping -%}
      {%- if parent == "" -%}
        {{ f(k, v) }}
      {%- else -%}
        {{ f(parent + "." + k, v) }}
      {%- endif -%}
    {%- else -%}
      {%- if parent == "" -%}
        {{k}} = {{v}}
      {%- else -%}
        {{parent}}.{{k}} = {{v}}
{% endif -%}
    {%- endif -%}
  {%- endfor -%}
{%- endmacro -%}

{{ f("", default_usergui_properties | combine(usergui_properties, recursive=True)) }}
```

If you rerun the ansible ad-hoc command above you should now have a file in
your current directory called `usergui.properties` with content similar to the
following (order my differ)

```
colors.foreground = #000080
colors.primary = #FFFFFF
colors.background = #000000
window.width = 500
window.height = 300
```

As a final pointer, I would recommend making it clear in your documentation
which variables should be considered 'private' and which ones the user can
overload. Hopefully you got something useful out of this, a similar thing can
be done to template out ini files check back soon for a how-to on this as well.


