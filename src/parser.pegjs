start
  = (literal / plural / variable)*


plural
  = "{{" forms:plural_forms "}}" anchor:plural_anchor? {
      return {
        type:   'plural',
        forms:  forms,
        anchor: anchor || 'count'
      };
    }


plural_forms
  = part:plural_part "|" more:plural_forms {
      return [part].concat(more);
    }
  / part:plural_part {
      return [part];
    }


plural_part
  = chars:plural_char+ {
      return chars.join('');
    }


plural_char
  = "\\" char:. { return String(char); }
  / [^|}\\]


plural_anchor
  = ":" name:identifier {
      return name;
    }


variable
  = "%{" anchor:identifier "}" {
      return {
        type:   'variable',
        anchor: anchor
      };
    }


identifier
  = a:identifier_part "." b:identifier+ {
      return a + "." + b;
    }
  / identifier_part


identifier_part
  = a:[a-z_$] b:[a-z0-9_$]* {
      return a + b.join("");
    }


literal
  = chars:literal_char+ {
      return {
        type: 'literal',
        text: chars.join('')
      };
    }


literal_char
  // any Unicode character except % or { or \ or control character
  = [^%{\\\0-\x1F\x7f]
  / "\\" char:. {
      return String(char);
    }
