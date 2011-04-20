/**
 * Message Block JavaScript Interface
 * 
 * Allows for updating a message block with JSON errors
 **/

var MessageBlock = Class.create({
  initialize: function(message_block) {
    this.message_block = $(message_block ? message_block : "message_block");
  },
  
  clear: function() {
    this.message_block.update("");
    new Effect.Fade(this.message_block);
  },
  
  update: function(errors) {
    if (!errors || Object.keys(errors).size() == 0) {
      new Effect.Fade(this.message_block);
      return;
    }
    
    this.message_block.update("");
    
    for (error_type in errors) {
      $(this.message_block).appendChild(
        Builder.node('ul', { 'class': error_type },
          $A(errors[error_type]).map(function(error) {
            return Builder.node('li', error);
          })
        )
      );
    }
    
    new Effect.Appear(this.message_block);
  }
});
