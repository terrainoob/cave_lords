module GuiElements
  class << self
    #
    # Create a button gui element
    #
    # @param [Hash] display_opts optional options for button formatting
    # @option display_opts [Integer] :display_row the DragonRuby screen row the button will appear in (1-12)
    # @option display_opts [Integer] :display_col the DragonRuby screen column the button will appear in (1-24)
    # @option display_opts [Integer] :width the width in columns
    # @option display_opts [Integer] :height the height in rows
    # @option display_opts [Integer] :red the red rgb value of the button's color
    # @option display_opts [Integer] :green the green rgb value of the button's color
    # @option display_opts [Integer] :blue the blue rgb value of the button's color
    # @option display_opts [String] :display_text The text that should appear on the button
    #
    # @param [Hash] opts arbitrary options that can be passed through
    # @param [<Type>] callback_method <description>
    # @param [?] args <description>
    #
    # @return [Hash] a hash of values for the button
    # @option return [method] :m callback method the button will execute
    # @option return [layout.rect] :rect the render rectangle of the button
    # @option return [Array] :primitives the render primitive definitions of the button
    # @option return [Hash] :ops passes back the opts hash that was passed in
    #
    def button(display_opts = {}, opts = {}, callback_method, args)
      display_opts = {
        display_row: 1,
        display_col: 1,
        width: 2,
        height: 1,
        red: 150,
        green: 200,
        blue: 200,
        display_text: 'Default Text'
      }.merge(display_opts)

      rect = args.layout.rect(
        row: display_opts[:display_row],
        col: display_opts[:display_col],
        w: display_opts[:width],
        h: display_opts[:height]
      )
      {
        m: callback_method,
        rect: rect,
        primitives: [
          { r: 150, g: 200, b: 200 }.merge(rect).solid!,
          {
            x: rect.x + (rect.w / 2),
            y: rect.y + (rect.h / 2),
            text: display_opts[:display_text],
            vertical_alignment_enum: 1,
            alignment_enum: 1
          }
        ]
      }
    end
  end
end
