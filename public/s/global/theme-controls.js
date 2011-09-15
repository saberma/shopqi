(function() {
  function themeResetURL() {
    var path = document.location.pathname;
    var query = document.location.search;
    var separator = (query.length > 0) ? '&' : '?';
    return path+query+separator+"preview_theme_id=";
  }
  function hideLink() {
    var label = '^'
    var title = '隐藏此提示'
    var onclick = 'var div=document.getElementById(\'shopqi-theme-controls\');div.style.top=\'-\'+div.offsetHeight+\'px\';return false;';
    return '<a class="hide" href="#" title="'+title+'" onclick="'+onclick+'">'+label+'</a>';
  }
  function cancelLink() {
    var label = 'X'
    var title = '取消预览'
    return '<a class="cancel" href="'+themeResetURL()+'" title="'+title+'">'+label+'</a>'
  }
  var div = document.createElement('div');
  div.setAttribute('id','shopqi-theme-controls');
  var title        = '<span class="title">主题预览: '+ShopQi.theme.name+'</span>';
  var links        = '<ul class="links"><li>'+hideLink()+'</li><li>'+cancelLink()+'</li></ul>';
  div.innerHTML    = title+links;
  document.body.appendChild(div);
})();
