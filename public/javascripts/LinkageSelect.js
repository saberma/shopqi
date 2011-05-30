/**
 * jQuery多级联动菜单
 * 
 * Author:	ZhouFan <happyeddie@gmail.com>
 * 
 */

function LinkageSelect(options) {
	
	var bindEls	= new Array();
	var items	= {};
	
	// 默认参数
	var settings = {
		data		: {},
		file		: null,
		root		: '0',
		ajax		: null,
		timeout		: 30,
		method		: 'post',
		field_name	: null,
		auto		: false
	}; 
	
	// 自定义参数
	if(options) {  
		jQuery.extend(settings, options); 
	}
	
	items	= settings.data;
	
	/**
	 * 绑定元素
	 * @param {Object} element
	 * @param {Object} value
	 */
	function _bind(element , value) {
		
		// 对象关联的key
		var key	= bindEls.length ?
			bindEls[bindEls.length - 1].key + ',' + bindEls[bindEls.length - 1].value :
			settings.root;
		
		// 将绑定的元素放入数组
		bindEls.push({
			element	: element,
			key		: key,
			value	: value
		});
		
		var item_count	= 0;
		for (var i in items) {
			item_count++;
		}
		
		// 查找自身id
		for (var el_id in bindEls) {
			if (bindEls[el_id].element == element) {
				var self_id	= parseInt(el_id);
			}
		}
		
		for(var el_id in bindEls){
			// 为所有前面的对象增加onchange事件，onchange时，清空自身
			if (el_id < self_id){
				bindEls[el_id].element.change(function() {
					_fill(element);
				})
			}
		}
		
		// 为上一级对象增加onchange事件，以刷新自身列表
		if (self_id > 0) {
			bindEls[self_id-1].element.change(function() {
				_fill(element , bindEls[self_id].key);
			});
		}
		
		element.change(function() {
			var self_key			= bindEls[self_id-1]?bindEls[self_id].key + ',' + $(this).val():'0,' + $(this).val();
			if (typeof bindEls[self_id+1] != 'undefined') {
				bindEls[self_id+1].key	= self_key;
			}
			
			// 自动填入所选值
			if (settings.field_name) {
				$(settings.field_name).val($(this).val());
			}
			
			if (settings.auto) {
				if (typeof bindEls[self_id+1] == 'undefined') {
					_find(self_key , function(key , json) {
						if (json) {
							var el	= $('<select></select>');
							element.after(el);
							_bind(el , '');
							_fill(bindEls[self_id+1].element , key , json);
						}
					});
				}
			}
		})
		_fill(element , key , value);
		
	}
	
	/**
	 * 填充option
	 * @param {Object} element
	 * @param {Object} key
	 * @param {Object} value
	 */
	function _fill(element , key , value) {
		
		element.empty();
		element.append('<option value="">请选择</option>');
		
		var json	= _find(key , function() {
			_fill(element , key , value);
		});
		
		if (!json) {
			if (settings.auto)
				element.hide();
			return false;
		}
		element.show();
		var index	= 1;
		var selected_index	= 0;
		for(var opt_value in json) {
			var opt_title	= json[opt_value];
			var selected	= '';
			if (opt_value == value) {
				selected_index	= index;
				selected		= 'selected="selected"';
			}
			var option	= $('<option value="' + opt_value + '" ' + selected + '>' + opt_title + '</option>');
			element.append(option);
			index++;
		}
		
		if (element[0]) {
			//IE6
			setTimeout(function(){
				element[0].options[selected_index].selected = true;
			}, 0);
			// 让FF选中默认项
			element[0].selectedIndex	= 0;
			element.attr('selectedIndex' , selected_index);
		}
		element.width(element.width());
	}
	
	/**
	 * 查找元素
	 * @param {Object} key
	 */
	function _find(key , callback) {
		if (typeof key == 'undefined') {	// 若未定义key
			return null;
		} else if (key[key.length-1] == ',') {	// 若key以','结尾，肯定是取不到值
			return null
		} else if(typeof(items[key]) == "undefined") {
			
			// 计算items元素个数
			var item_count	= 0;
			for (var i in items) {
				item_count++;
				break;
			}
			
			if (settings.ajax) {
				$.getJSON(settings.ajax , {key:key} , function(json) {
					items[key] = json;
					callback(key , json);
				})
			} else if(settings.file && item_count == 0) {
				$.getJSON(settings.file , function(json) {
					items = json;
					callback(key , json);
				})
			}
		}
			
		return items[key];
	}
	
	/**
	 * 获取对象
	 * @param {Object} element
	 */
	function _getEl(element) {
		if (typeof element == 'string') {
			return $(element);
		} else {
			return element;
		}
	}
	
	
	return {
		
		// 绑定元素
		bind	: function(element , value) {
			if (typeof element != 'object')
				element	= _getEl(element);
			value	= value?value:'';
			
			_bind(element , value);
			
		}
	}
}
