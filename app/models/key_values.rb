# encoding: utf-8
module KeyValues

  class Base < ActiveHash::Base
    def self.options
      all.map {|t| [t.name, t.code]}
    end

    # {code1: name1, code2: name2}
    def self.hash
      Hash[*(all.map{|t| [t.code, t.name]}.flatten)]
    end
  end

  class CancelReason < KeyValues::Base
    self.data = [
      {id: 1, name: '很难使用'    , code: 'difficulty_to_use' },
      {id: 2, name: '需要其它功能', code: 'need_new_feature'  },
      {id: 3, name: '帮助不详细'  , code: 'cant_find_help'    },
      {id: 4, name: '费用太贵'    , code: 'plan_are_expensive'},
      {id: 5, name: '其它'        , code: 'difficulty_to_use' },
    ]
  end

  class Resource < KeyValues::Base
    include ActiveHash::Associations
    belongs_to :resource_type , class_name: 'KeyValues::ResourceType'
    self.data = [
      {id: 1 , name: '首页'        , code: 'home'              ,resource_type_id: 1},
      {id: 2 , name: '顾客'        , code: 'customers'         ,resource_type_id: 1},
      {id: 3 , name: '订单'        , code: 'orders'            ,resource_type_id: 1},
      {id: 4 , name: '促销'        , code: 'marketing'         ,resource_type_id: 1},
      {id: 5 , name: '商品&集合'   , code: 'products'          ,resource_type_id: 2},
      {id: 6 , name: '外观'        , code: 'themes'            ,resource_type_id: 2},
      {id: 7 , name: '博客&页面'   , code: 'pages'             ,resource_type_id: 2},
      {id: 8 , name: '链接列表'    , code: 'link_lists'        ,resource_type_id: 2},
      {id: 9 , name: '应用'        , code: 'applications'      ,resource_type_id: 3},
      {id: 10, name: '设置'        , code: 'preferences'       ,resource_type_id: 3},
    ]
  end

  class ResourceType < KeyValues::Base
    include ActiveHash::Associations
    has_many :resources , class_name: 'KeyValues::Resource'
    self.data = [
      {id: 1, name: '商店管理'},
      {id: 2, name: '商店内容'},
      {id: 3, name: '商店设置'},
    ]
  end

  #支付类型
  class PaymentType < KeyValues::Base
    self.data = [
      {id: 1, name: '在线支付-支付宝', link: 'https://b.alipay.com/order/productSign.htm?action=newsign&productId=2011011904422299'},
      {id: 2, name: '在线支付-财付通', link: 'http://union.tenpay.com/mch/mch_register.shtml'},
      {id: 3, name: '在线支付-快钱'  , link: 'http://www.99bill.com'}
    ]
  end

  #评论状态
  class CommentableType < KeyValues::Base
    self.data = [
      {id: 1, name: '禁用评论'              , code: 'no'},
      {id: 2, name: '允许评论,需审核'       , code: 'moderate'},
      {id: 3, name: '允许评论，并且自动发布', code: 'yes'},
    ]
  end

  class PolicyType < KeyValues::Base
    self.data = [
      {id: 1, name: '退款政策'},
      {id: 2, name: '隐私政策'},
      {id: 3, name: '服务条款'}
    ]
  end

  # 是否发布
  class PublishState < KeyValues::Base
    self.data = [
      {id: 1, name: '公开', code: 'true'},
      {id: 2, name: '隐藏', code: 'false'},
    ]
  end

  #评论状态
  class CommentState < KeyValues::Base
    self.data = [
      {id: 1, name: '垃圾的', code: 'spam'},
      {id: 2, name: '未接收的'  , code: 'unapproved'},
      {id: 3, name: '公开的'  , code: 'published'},
    ]
  end


  # 每页条数
  class PageSize < KeyValues::Base
    self.data = [
      {id: 1, name: '25' , code: '25' },
      {id: 2, name: '50' , code: '50' } ,
      {id: 3, name: '100', code: '100'},
      {id: 4, name: '250', code: '250'},
    ]
  end

  module Shop # 商店

    class SignupSource < KeyValues::Base # 注册来源
      self.data = [
        {id: 1, name: '我不确定'    , code: 'not_sure'    },
        {id: 2, name: '其他公司介绍', code: 'from_company'},
        {id: 3, name: '朋友介绍'    , code: 'from_frient' },
        {id: 4, name: '博客'        , code: 'blog'        },
        {id: 5, name: '搜索引擎'    , code: 'search'      },
        {id: 6, name: '网络广告'    , code: 'web_ad'      },
        {id: 7, name: '杂志广告'    , code: 'magazine_ad' },
        {id: 8, name: '书籍'        , code: 'book'        },
        {id: 9, name: '其他'        , code: 'other'       },
      ]
    end

    class Currency < KeyValues::Base # 币种
      self.data = [
        {id: 1, name: '人民币 (CNY)', code: 'CNY', html_unit: '&#165;{{amount}} 元' , html: '&#165;{{amount}}' , email_unit: '¥{{amount}} 元' , email: '¥{{amount}}' },
        {id: 2, name: '美元 (USD)'  , code: 'USD', html_unit: '${{amount}} USD'     , html: '${{amount}}'      , email_unit: '${{amount}} USD', email: '${{amount}}' } ,
        {id: 3, name: '欧元 (EUR)'  , code: 'EUR', html_unit: '&euro;{{amount}} EUR', html: '&euro;{{amount}}' , email_unit: '€{{amount}} EUR', email: '€{{amount}}' } ,
        {id: 4, name: '港元 (HKD)'  , code: 'HKD', html_unit: 'HK${{amount}}'       , html: '${{amount}}'      , email_unit: 'HK${{amount}}'  , email: '${{amount}}' } ,
      ]
    end

  end

  module Theme # 主题

    class Role < KeyValues::Base # 发布类型
      self.data = [
        {id: 1, name: '普通', code: 'main'  },
        {id: 2, name: '手机', code: 'mobile'},
      ]
    end

  end

  module Payment

    class Custom < KeyValues::Base
        self.data = [
          {id: 1   ,name: '银行转账' , code: 'bank_transfer'},
          {id: 2   ,name: '邮局汇款' , code: 'pos'},
          {id: 3   ,name: '货到付款' , code: 'cod'}
        ]
    end

    module Alipay

      class Service < KeyValues::Base # 支付接口
        self.data = [
          {id: 1, name: '即时到帐'  , code: ActiveMerchant::Billing::Integrations::Alipay::Helper::CREATE_DIRECT_PAY_BY_USER     },
          {id: 2, name: '担保交易'  , code: ActiveMerchant::Billing::Integrations::Alipay::Helper::CREATE_PARTNER_TRADE_BY_BUYER },
          {id: 3, name: '双功能收款', code: ActiveMerchant::Billing::Integrations::Alipay::Helper::TRADE_CREATE_BY_BUYER         }
        ]
      end

    end

    module Tenpay

      class Service < KeyValues::Base # 支付接口
        self.data = [
          {id: 1, name: '即时到帐交易'  , code: 'direct' },
          {id: 2, name: '中价担保交易'  , code: 'protect'}
        ]
      end

    end

  end

  module Plan
    class Type < KeyValues::Base
      self.data = [
        {id: 1   ,name:'旗舰版'  , code: 'unlimited'    , skus: 1000 , storage: 1000, price: 9988 },
        {id: 2   ,name:'企业版'  , code: 'business'     , skus: 500  , storage: 500 , price: 5988 },
        {id: 3   ,name:'专业版'  , code: 'professional' , skus: 100  , storage: 100 , price: 2988 },
        {id: 4   ,name:'免费版'  , code: 'free'         , skus: 50   , storage: 50  , price: 0    }
      ]

      def free?
        self.code == 'free'
      end
    end
  end

  module Mail

    class Type < KeyValues::Base
        self.data = [
          {id: 10, name: '订单确认提醒'            , code: 'order_confirm'                 , des: '当订单创建时，给客户发送此邮件'                                  },
          {id: 20, name: '新订单提醒'              , code: 'new_order_notify'              , des: '当有新订单创建时，给网店管理者发送此邮件'                        },
          #{id: 25, name: '新订单提醒(手机)'        , code: 'new_order_notify_mobile'       , des: '当有新订单创建时，给网店管理者发送此手机短信'                    },
          {id: 30, name: '货物发送提醒'            , code: 'ship_confirm'                  , des: '当客户的订单的货物发送时，给客户发送此邮件'                      },
          {id: 40, name: '货物发送信息更改提醒'    , code: 'ship_update'                   , des: '当订单的发送信息变更时，给客户发送此邮件'                        },
          #{id: 50, name: '联系买家'                , code: 'contact_buyer'                 , des: '在订单页面点击"发送邮件"时显示的邮件内容'                        },
          {id: 60, name: '订单取消提醒'            , code: 'order_cancelled'               , des: '当订单取消时，给客户发送此邮件'                                  },
          #{id: 70, name: '顾客帐号激活提醒'        , code: 'customer_account_activation'   , des: '当客户创建帐号时，告知客户如何激活帐户,给客户发送此邮件'         }, # 暂不需要
          #{id: 80, name: '顾客帐号密码更改提醒'    , code: 'customer_password_reset'       , des: '当客户需要密码变更时，给客户发送此邮件'                          },
          #{id: 90, name: '顾客帐号确认提醒'        , code: 'customer_account_welcome'      , des: '当客户激活了帐户时，给客户发送此邮件'                            }
        ]

        def title_body
          title = Rails.cache.fetch "shopqi_templates_emails_#{self.code}_title" do
            File.read(Rails.root.join("app/views/admin/templates/emails/#{self.code}_title.liquid"))
          end
          body = Rails.cache.fetch "shopqi_templates_emails_#{self.code}_body" do
            File.read(Rails.root.join("app/views/admin/templates/emails/#{self.code}_body.liquid"))
          end
          [title, body]
        end
    end
  end

  # 商品相关
  module Product

    module Inventory

      class Manage < KeyValues::Base
        self.data = [
          {id: 1, name: '不需要跟踪库存情况'            , code: ''      },
          {id: 2, name: '需要ShopQi跟踪此款式的库存情况', code: 'shopqi'}
        ]
      end

      class Policy < KeyValues::Base
        self.data = [
          {id: 1, name: '库存不足时拒绝用户购买此款商品'    , code: 'deny'    },
          {id: 2, name: '允许用户购买此款商品，即使库存不足', code: 'continue'}
        ]
      end

    end

    # 商品款式选项
    class Option < KeyValues::Base
      self.data = [
        {id: 1, name: '标题', code: 'title'    },
        {id: 2, name: '大小', code: 'size'     },
        {id: 3, name: '颜色', code: 'color'    },
        {id: 4, name: '材料', code: 'material' },
        {id: 5, name: '风格', code: 'style'    }
      ]
    end

  end

  # 顾客
  module Customer

    class Boolean < KeyValues::Base
      self.data = [
        {id: 1, name: '是', code: true },
        {id: 2, name: '否', code: false},
      ]
    end

    class State < KeyValues::Base
      self.data = [
        {id: 1, name: '已启用', code: 'enabled' },
        {id: 2, name: '已禁用', code: 'disabled'},
        {id: 3, name: '已邀请', code: 'invited' },
        {id: 4, name: '被拒绝', code: 'declined'}, #发送邀请邮件后顾客拒绝注册
      ]
    end

    # 过滤器
    class PrimaryFilter < KeyValues::Base
      self.data = [
        {id: 1, name: '消费金额'    , code: 'total_spent'              , clazz: 'integer'},
        {id: 2, name: '订单数'      , code: 'orders_count'             , clazz: 'integer'},
        {id: 3, name: '下单时间'    , code: 'last_order_date'          , clazz: 'date'   },
        #{id: 4, name: '所在城市'   , code: 'city'                     , clazz: 'city'   },
        {id: 5, name: '接收营销邮件', code: 'accepts_marketing'        , clazz: 'boolean'},
        {id: 6, name: '放弃订单时间', code: 'last_abandoned_order_date', clazz: 'date'   },
        #{id: 7, name: '订单标签'   , code: 'tag'                      , clazz: 'tag'    },
        {id: 8, name: '帐号状态'    , code: 'status'                   , clazz: 'status' }
      ]
    end

    # 过滤器条件
    module SecondaryFilter

      class Integer < KeyValues::Base
        self.data = [
          {id: 1, name: '大于', code: 'gt'},
          {id: 2, name: '小于', code: 'lt'},
          {id: 3, name: '等于', code: 'eq' }
        ]
      end

      class Date < KeyValues::Base
        self.data = [
          {id: 1, name: '在最近一周'  , code: 'last_week'    },
          {id: 2, name: '在最近一个月', code: 'last_month'   },
          {id: 3, name: '在最近三个月', code: 'last_3_months'},
          {id: 4, name: '在最近一年'  , code: 'last_year'    },
        ]
      end

    end

  end

  # 订单
  module Order

    # 状态
    class Status < KeyValues::Base
      self.data = [
        {id: 1, name: '正常'  , code: 'open'    },
        {id: 2, name: '已关闭', code: 'closed'  },
        {id: 3, name: '已取消', code: 'cancelled'}
      ]
    end

    # 支付状态
    class FinancialStatus < KeyValues::Base
      self.data = [
        {id: 1, name: '已支付', code: 'paid'      },
        {id: 2, name: '待支付', code: 'pending'   },
        {id: 3, name: '认证'  , code: 'authorized'},
        {id: 4, name: '放弃'  , code: 'abandoned' },
      ]
    end

    # 配送状态
    class FulfillmentStatus < KeyValues::Base
      self.data = [
        {id: 1, name: '已发货'  , code: 'fulfilled'},
        {id: 2, name: '部分发货', code: 'partial'  },
        {id: 3, name: '未发货'  , code: 'unshipped'}
      ]
    end

    class CancelReason < KeyValues::Base # 取消原因
      self.data = [
        {id: 1, name: '顾客改变/取消订单', code: 'customer'    },
        {id: 2, name: '重复订单'         , code: 'duplicate'   },
        {id: 3, name: '没有及时付款'     , code: 'not_pay'     },
        {id: 4, name: '欺诈性订单'       , code: 'fraud'       },
        {id: 5, name: '没有商品了'       , code: 'inventory'   },
        {id: 6, name: '其他'             , code: 'other'       }
      ]
    end

    class TrackingCompany < KeyValues::Base # 快递公司
      self.data = [
        {id: 1,  name: '顺丰快递' , code: '顺丰快递' , url: 'http://www.sf-express.com/cn/sc' },
        {id: 2,  name: 'EMS'      , code: 'EMS'      , url: 'http://www.ems.com.cn'           },
        {id: 3,  name: '申通E物流', code: '申通E物流', url: 'http://www.sto.cn'               },
        {id: 4,  name: '圆通速递' , code: '圆通速递' , url: 'http://www.yto.net.cn'           },
        {id: 5,  name: '中通速递' , code: '中通速递' , url: 'http://www.zto.cn'               },
        {id: 6,  name: '宅急送'   , code: '宅急送'   , url: 'http://www.zjs.com.cn'           },
        {id: 7,  name: '韵达快运' , code: '韵达快运' , url: 'http://www.yundaex.com'          },
        {id: 8,  name: '天天快递' , code: '天天快递' , url: 'http://www.ttkdex.com'           },
        {id: 9,  name: '联邦快递' , code: '联邦快递' , url: 'http://www.fedex.com/cn'         },
        {id: 10, name: '汇通快运' , code: '汇通快运' , url: 'http://www.htky365.com'          },
        #{id: 11, name: '华强物流' , code: '华强物流' , url: ''                               },
        {id: 12, name: '其它'     , code: '其它'     , url: ''                                }
      ]

      def self.url(name) # 根据公司名称获取url地址
        self.find_by_name(name).try(:url)
      end
    end

  end

  module Link

    #链接类型
    class Type < KeyValues::Base
      self.data = [
        {id: 1, name: '博客'    , code: 'blog'      },
        {id: 2, name: '商店首页', code: 'frontpage' },
        {id: 3, name: '商品集合', code: 'collection'},
        {id: 4, name: '指定页面', code: 'page'      },
        {id: 5, name: '指定商品', code: 'product'   },
        {id: 6, name: '查询页面', code: 'search'    },
        {id: 7, name: '其他网址', code: 'http'      }
      ]
    end

  end

  module Collection

    #规则相关列
    class Column < KeyValues::Base
      self.data = [
        {id: 1, name: '商品名称', code: 'title'                      , clazz: 'string'  },
        {id: 2, name: '商品类型', code: 'product_type'               , clazz: 'string'  },
        {id: 3, name: '商品厂商', code: 'vendor'                     , clazz: 'string'  },
        {id: 4, name: '商品价格', code: 'variants_price'             , clazz: 'integer' },
        {id: 5, name: '比较价格', code: 'variants_compare_at_price'  , clazz: 'integer' },
        {id: 6, name: '库存现货', code: 'variants_inventory_quantity', clazz: 'integer' },
        {id: 7, name: '款式名称', code: 'variants_option1'           , clazz: 'string'  }
      ]
    end

    #规则关系
    class Relation < KeyValues::Base
      self.data = [
        {id: 1, name: '等于'    , code: 'equals'      , clazz: 'all'    },
        {id: 2, name: '大于'    , code: 'greater_than', clazz: 'integer'},
        {id: 3, name: '小于'    , code: 'less_than'   , clazz: 'integer'},
        {id: 4, name: '以此开头', code: 'starts_with' , clazz: 'string' },
        {id: 5, name: '以此结束', code: 'ends_with'   , clazz: 'string' },
        {id: 6, name: '包含'    , code: 'contains'    , clazz: 'string' },
      ]
    end

    #排序
    class Order < KeyValues::Base
      self.data = [
        {id: 1 , name: '按标题拼音升序: A-Z'  , code: 'title.asc'      },
        {id: 2 , name: '按标题拼音降序: Z-A'  , code: 'title.desc'     },
        #{id: 3, name: '按销售量排序'         , code: 'best-selling'   },
        {id: 4 , name: '按创建日期: 最近-最远', code: 'created_at.desc'},
        {id: 5 , name: '按创建日期: 最远-最近', code: 'created_at.asc' },
        {id: 6 , name: '按价格排序: 最高-最低', code: 'price.desc'     },
        {id: 7 , name: '按价格排序: 最低-最高', code: 'price.asc'      },
        {id: 8 , name: '手动排序'             , code: 'manual'         },
      ]

      #手动排序?
      def self.is_manual?(order)
        'manual' == order
      end
    end

  end

  module WebHook

    class Event < KeyValues::Base # 事件
      self.data = [
        {id: 1, name: '创建购物车'  , code: 'carts/create'          },
        {id: 1, name: '更新购物车'  , code: 'carts/update'          },
        {id: 2, name: '新增集合'    , code: 'collections/create'    },
        {id: 2, name: '删除集合'    , code: 'collections/delete'    },
        {id: 2, name: '修改集合'    , code: 'collections/update'    },
        {id: 2, name: '新增顾客分组', code: 'customer_groups/create'},
        {id: 2, name: '删除顾客分组', code: 'customer_groups/delete'},
        {id: 2, name: '修改顾客分组', code: 'customer_groups/update'},
        {id: 2, name: '新增订单'    , code: 'orders/create'         },
        {id: 2, name: '修改订单'    , code: 'orders/update'         },
        {id: 2, name: '订单支付'    , code: 'orders/paid'           },
        {id: 2, name: '订单发货'    , code: 'orders/fulfilled'      },
        {id: 2, name: '取消订单'    , code: 'orders/cancelled'      },
        {id: 2, name: '新增商品'    , code: 'products/create'       },
        {id: 2, name: '删除商品'    , code: 'products/delete'       },
        {id: 2, name: '修改商品'    , code: 'products/update'       },
      ]
    end

  end

end

