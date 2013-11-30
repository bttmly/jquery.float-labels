do ( $ = jQuery ) ->

  $.fn.floatLabels = ( options ) ->
        
    options ?= {}
    
    defaults =
      floatOn    : "focus"
      activeClass : "label-active"
      filledClass : "label-filled"
      
    settings = $.extend( {}, defaults, options )
        
    this.each ( i, input ) ->
      $input = $( input )
      $label = if input.id then $("[for='#{input.id}']") else $("[for='#{input.name}']")
        
      if settings.floatOn is "focus"
        
        $input.bind( "focus", ->
            $label.addClass( settings.activeClass )
        ).bind( "blur", ->
          $label.removeClass( settings.activeClass )
          if input.value.length > 0
            $label.addClass( settings.filledClass )
          else
            $label.removeClass( settings.filledClass )
        ).trigger( "blur" )
      
      else if settings.floatOn is "entry"
        
        $input.bind( "focus", ->
          if this.value.length > 0
            $label.addClass( settings.activeClass )
        ).bind( "blur", ->
          if this.value.length > 0
            $label.addClass( settings.filledClass ).removeClass( settings.activeClass )
        ).bind( "keyup", ->
          if this.value.length > 0
            $label.addClass( settings.activeClass )
          else
            $label.removeClass( settings.activeClass + ' ' + settings.filledClass )
        ).trigger( "blur" )
      
      return this