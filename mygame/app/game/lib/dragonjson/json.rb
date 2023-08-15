module LevisLibs
  module JSON
    class JSONParser
      class UnexpectedChar < StandardError
      end

      WS = " \n\r\t".chars
      IS_WSPCE = -> (c) { WS.include?(c) }
      IS_1TO9 = -> (c) { ("1".."9") === c }
      IS_DIGIT = -> (c) { ("0".."9") === c }
      IS_ALPHA = -> (c) { ("a".."z") === c || ("A".."Z") === c || "_" == c }
      IS_ALNUM = -> (c) { IS_ALPHA[c] || IS_DIGIT[c] }

      def initialize(string)
        @len = string.size
        @str = string
        @idx = 0
        @col = 1
        @ln = 1
      end

      def parse(symbolize_keys: false, **kw)
        __parse_top(symbolize_keys: symbolize_keys, **kw)
      end

      def __advance
        c = @str[@idx]
        @idx += 1

        @col += 1
        if c == "\n"
          @ln += 1
          @col = 1
        end

        c
      end

      def __peek
        @str[@idx]
      end

      def __peek_prev
        @str[@idx - 1]
      end

      def __match!(c)
        if String === c
          if __peek == c
            __advance
            return true
          end
        elsif Proc === c
          if c[__peek]
            __advance
            return true
          end
        end

        return false
      end

      def __match_any!(*cs)
        cs.any? { __match!(_1) }
      end

      def __expect!(c)
        __match!(c) || raise(UnexpectedChar, "Expected #{c.inspect}, but got #{__peek.inspect} at #{@idx}, [#{@ln}:#{@col}]")
        __peek_prev
      end

      def __expect_any!(*cs)
        cs.any? { __match!(_1) } ||
          raise(UnexpectedChar, "Expected any of #{cs.map(&:inspect).join(", ")}, but got #{__peek.inspect}")
        __peek_prev
      end

      def __string(str)
        last = ""
        str.chars.all? {
          last = _1
          __match!(_1)
        } ||
          raise(UnexpectedChar, "Expected '#{last}', got '#{__peek}' (in \"#{str}\" literal)")
      end

      def __skip_ws
        __advance while IS_WSPCE[__peek]
      end

      def __parse_element(**kw)
        __skip_ws
        v = __parse_value(**kw)
        __skip_ws
        v
      end

      alias __parse_top __parse_element

      def __parse_value(extensions: false, **kw)
        case __peek
        when "{"
          __advance
          __skip_ws
          return {} if __match!("}")

          hsh = __parse_members(extensions: extensions, **kw)
          __expect!("}")

          if extensions
            hsh = __handle_parser_extensions(hsh, symbolize_keys: kw[:symbolize_keys], **kw)
          end

          hsh
        when "["
          __advance
          __skip_ws
          return [] if __match!("]")

          ary = __parse_elements(extensions: extensions, **kw)
          __expect!("]")
          ary
        when "\""
          __parse_string(**kw)
        when "-", "0".."9"
          __parse_number(**kw)
        when "t"
          __string("true")
          true
        when "f"
          __string("false")
          false
        when "n"
          __string("null")
          nil
        else
          raise UnexpectedChar, "Unexpected char '#{__peek}' at [#{@ln}:#{@col}]"
        end
      end

      def __parse_number(**kw)
        start = @idx
        __read_integer || raise(
          UnexpectedChar,
          "Expected the integer part of a numeric literal, got '#{__peek}', [#{@ln}:#{@col}]"
        )
        iend = @idx

        __read_frac ||
          raise(
            UnexpectedChar,
            "Expected nothing or the fractional part of a numeric literal, got '#{__peek}', [#{@ln}:#{@col}]"
          )
        __read_exp ||
          raise(
            UnexpectedChar,
            "Expected nothing or the exponent part of a numeric literal, got '#{__peek}' [#{@ln}:#{@col}]"
          )
        nend = @idx

        if iend == nend
          @str[start..@idx].to_i
        else
          @str[start..@idx].to_f
        end
      end

      def __read_unsigned_integer(**kw)
        __read_onenine_digits || __read_digit
      end

      def __read_integer(**kw)
        __read_unsigned_integer || (__match!("-") && __read_unsigned_integer)
      end

      def __read_frac(**kw)
        if __match!(".")
          __read_some_digits(**kw)
        else
          true
        end
      end

      def __read_exp(**kw)
        if __match_any!("e", "E")
          __read_sign(**kw) && __read_some_digits(**kw)
        else
          true
        end
      end

      def __read_sign(**kw)
        __match_any!("-", "+")
        true
      end

      def __read_digit(**kw)
        IS_DIGIT[__peek] && __advance
      end

      def __read_onenine(**kw)
        IS_1TO9[__peek] && __advance
      end

      def __read_onenine_digits(**kw)
        __read_onenine(**kw) && __read_many_digits(**kw)
      end

      def __read_many_digits(**kw)
        next while __read_digit(**kw)
        true
      end

      def __read_some_digits(**kw)
        any = false
        any = true while __read_digit(**kw)
        any
      end

      def __parse_characters(**kw)
        str = ""
        nil while (__read_escape(str, **kw) || __read_characters(str, **kw))
        str
      end

      def __read_characters(str, **kw)
        any = false
        start = @idx
        while true
          break if !__match!(-> (c) { ("\x20".."\xf4\x8f\xbf\xbf") === c && !(c == "\"" || c == "\\") })
          any = true
        end

        str << @str[start..@idx - 1]
        any
      end

      def __read_escape(str, **kw)
        __match!("\\") &&
          (__expect_any!("\"", "\\", "/", "b", "f", "n", "r", "t", "u") &&
            case __peek_prev
            when "\""
              str << "\""
            when "\\"
              str << "\\"
            when "/"
              str << "/"
            when "b"
              str << "\b"
            when "f"
              str << "\f"
            when "n"
              str << "\n"
            when "r"
              str << "\r"
            when "t"
              str << "\t"
            when "u"
              raise(NotImplementedError, "unicode escapes not yet implemented")
            end)
      end

      def __parse_elements(**kw)
        ary = [__parse_element(**kw)]
        while __match!(",")
          ary << __parse_element(**kw)
        end

        ary
      end

      def __parse_string(**kw)
        __expect!("\"")
        str = __parse_characters(**kw)
        __expect!("\"")
        str
      end

      def __parse_members(**kw)
        hsh = {}
        key, value = __parse_member(**kw)
        hsh[key] = value
        while __match!(",")
          key, value = __parse_member(**kw)
          hsh[key] = value
        end

        hsh
      end

      def __parse_member(**kw)
        __skip_ws
        key = __parse_string(**kw)
        __skip_ws
        __expect!(":")
        (value = __parse_element(**kw))
        [kw[:symbolize_keys] ? key.to_sym : key, value]
      end

      def __handle_symbol_extension(hsh, symbolize_keys: false, **kw)
        hsh[symbolize_keys ? :"@@jm:symbol" : "@@jm:symbol"]&.to_sym
      end

      def __handle_object_extension(hsh, symbolize_keys: false, **kw)
        class_key = symbolize_keys ? :"@@jm:class" : "@@jm:class"

        classname = hsh[class_key]
        return if !classname

        klass = Object.const_get(classname)

        if !klass.respond_to?(:from_json)
          raise JSONUnsupportedType, "class #{classname} doesn't implement the `from_json` method"
        end

        value_key = symbolize_keys ? :"@@jm:value" : "@@jm:value"
        return if !hsh.key?(value_key)
        value = hsh[value_key]

        klass.from_json(value)
      end

      def __handle_parser_extensions(hsh, symbolize_keys: false, **kw)
        (if hsh.size == 1
          __handle_symbol_extension(hsh, symbolize_keys: symbolize_keys, **kw)
        elsif hsh.size == 2
          __handle_object_extension(hsh, symbolize_keys: symbolize_keys, **kw)
        end) ||
          hsh
      end
    end

    class JSONKeyError < StandardError
    end

    class JSONUnsupportedType < StandardError
    end

    class << self
      def write(value, indent_size = 4, **kw)
        raise ArgumentError, "Top-level value must be either an Array or a Hash" unless Array === value || Hash === value

        value.to_json(
          indent_depth: 0,
          indent_size: indent_size,
          minify: indent_size == -1,
          **kw
        )
      end

      def parse(
        string,
        **kw
      )
        JSONParser.new(string).parse(**kw)
      end
    end

    class ::Hash
      def to_json(
        indent_depth: 0,
        indent_size: 4,
        minify: false,
        space_in_empty: true,
        **kw
      )
        raise JSONKeyError, "Not all keys are instances of `String` or `Symbol`" if !keys.all? { String === _1 || Symbol === _1 }

        return "{#{space_in_empty && !minify ? " " : ""}}" if self.length == 0

        space = minify ? "" : " "
        pairs = self.map { |k, v| "#{k.to_json(extensions: false)}:#{space}#{v.to_json(indent_depth: indent_depth + 1, indent_size: indent_size, minify: minify, space_in_empty: space_in_empty, **kw)}" }

        if minify
          "{#{pairs.join(",")}}"
        else
          indent = " " * (indent_depth * indent_size)
          indent_p1 = " " * ((indent_depth + 1) * indent_size)
          "{\n#{indent_p1}#{pairs.join(",\n#{indent_p1}")}\n#{indent}}"
        end
      end
    end

    class ::Array
      def to_json(
        indent_depth: 0,
        indent_size: 4,
        minify: false,
        space_in_empty: true,
        **kw
      )
        return "[#{space_in_empty && !minify ? " " : ""}]" if self.length == 0

        space = minify ? "" : " "
        values = self.map { |v| "#{v.to_json(indent_depth: indent_depth + 1, indent_size: indent_size, minify: minify, space_in_empty: space_in_empty, **kw)}" }

        if minify
          "[#{values.join(",")}]"
        else
          indent = " " * (indent_depth * indent_size)
          indent_p1 = " " * ((indent_depth + 1) * indent_size)
          "[\n#{indent_p1}#{values.join(",\n#{indent_p1}")}\n#{indent}]"
        end
      end
    end

    class ::Numeric
      def to_json(
        **kw
      )
        self.inspect
      end
    end

    class ::TrueClass
      def to_json(
        **kw
      )
        "true"
      end
    end

    class ::FalseClass
      def to_json(
        **kw
      )
        "false"
      end
    end

    class ::NilClass
      def to_json(
        **kw
      )
        "null"
      end
    end

    class ::String
      def to_json(
        **kw
      )
        self.inspect
      end
    end

    class ::Symbol
      def to_json(
        extensions: false,
        symbolize_keys: false,
        **kw
      )
        if extensions
          {:"@@jm:symbol" => self.to_s}.to_json(**kw, minify: true)
        else
          self.to_s.inspect
        end
      end
    end

    class ::Object
      def to_json(
        value: nil,
        **kw
      )
        if self.class.instance_method(__method__).owner == Object
          raise JSONUnsupportedType, "Object of class #{self.class.name} cannot be serialized to JSON"
        end

        {
          "@@jm:class" => self.class.name,
          "@@jm:value" => value
        }.to_json(**kw)
      end
    end
  end

  class ::GTK::Runtime
    def write_json(filename, hash_or_array, indent_size = 4, **kw)
      write_file(filename, hash_or_array.to_json(indent_size: indent_size, minify: indent_size == -1, **kw))
    end
  end
end
