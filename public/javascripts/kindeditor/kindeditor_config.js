csrf_param = $('meta[name=csrf-param]').attr('content')
csrf_token = encodeURIComponent($('meta[name=csrf-token]').attr('content')) //fixed: + was replace with space
KE.show({
    id : 'kindeditor',
    allowFileManager : true,
    imageUploadJson:'/kindeditor/upload_image?'+csrf_param+'='+csrf_token,
    items : ['source','|','fullscreen', 'undo', 'redo',  'cut', 'copy', 'paste',
              'plainpaste',  '|', 'justifyleft', 'justifycenter', 'justifyright',
              'justifyfull', 'insertorderedlist', 'insertunorderedlist', 'indent', 'outdent', 'subscript',
              'superscript', '|', 'selectall','title', 'fontname', 'fontsize', '|', 'textcolor', 'bgcolor', 'bold',
              'italic', 'underline', 'strikethrough', 'removeformat', '|', 'image',
              'advtable', 'hr', 'emoticons', 'link', 'unlink']
});
