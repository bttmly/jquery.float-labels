do ( $ = jQuery ) ->

  # pattern based on https://gist.github.com/chikamichi/5417680
  $.fn.floatLabels = ( method ) ->
    
    if methods[method]
      methods[method].apply( this, Array::slice.call( arguments, 1) )

    # floatLabels.make is the default method
    else if $.isPlainObject( method ) or not methods[method]
      methods.make.apply( this, arguments )

    else
      $.error( "Method #{method} does not exist on jQuery.floatLabels")

  settings = {}

  methods =

    make : ( options ) ->

      options or= {}

      defaults =
        floatOn     : "focus"
        activeClass : "float-label-active"
        filledClass : "float-label-filled"
        inputClass  : "float-label-input"

      settings = $.extend( {}, defaults, ( options or {} ) )
      
      hasVal = ( el ) ->
          if el.value.length is 0 then return false else return true

      this.addClass( defaults.inputClass )

      this.each ( i, input ) ->
        $input = $( input )
        $label = if input.id then $("[for='#{input.id}']") else $("[for='#{input.name}']")

        switch settings.floatOn

          when "focus"
            $input
            .bind "focus.floatLabel", ->
                $label.addClass( settings.activeClass )
            .bind "blur.floatLabel", ->
              $label.removeClass( settings.activeClass )
              if hasVal( this )
                $label.addClass( settings.filledClass )
              else
                $label.removeClass( settings.filledClass )
            .trigger( "blur.floatLabel" )
        
          when "entry"
            $input
            .bind "focus.floatLabel", ->
              if hasVal( this )
                $label.addClass( settings.activeClass )
            .bind "blur.floatLabel", ->
              if hasVal( this )
                $label.addClass( settings.filledClass ).removeClass( settings.activeClass )
            .bind "keydown.floatLabel", ->
              if hasVal( this )
                $label.addClass( settings.activeClass )
              else
                $label.removeClass( "#{settings.activeClass} #{settingsfilledClass}" )
            .trigger( "blur.floatLabel" )

          else
            console.warn "Invalid floatOn option: #{settings.floatOn}"
        
        return this

    destroy : ->

      if settings.inputClass
        this.removeClass( settings.inputClass )

      this.each (i, input) ->

        $input = $( input )
        $label = if input.id then $("[for='#{input.id}']") else $("[for='#{input.name}']")

        $label.removeClass( "#{settings.activeClass} #{settingsfilledClass}" )

        $input
        .unbind( "focus.floatLabel" )
        .unbind( "blur.floatLabel" )
        .unbind( "keydown.floatLabel" )

      return this