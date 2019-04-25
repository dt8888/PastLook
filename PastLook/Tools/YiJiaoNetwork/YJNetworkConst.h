//
//  YJNetworkConst.h
//  YJJSApp
//
//  Created by DT on 2018/3/21.
//  Copyright © 2018年 dt. All rights reserved.
//

typedef enum{
     YJ_User_reply,    //这个地方标识 某个接口返回的 数据，对应找到的接口。
    YJ_commentNum,//评论数量
    IH_CommentsByStoreId,//评论
    IH_GetMyIncome,//个人收益
    IH_GetPayPassword,//支付密码
    IH_WXAuthorizationAccessToken,    //微信授权
    IH_WXAuthorizationRefreshToken,    //微信授权
    IH_WXAuthorizationUserinfo,      //微信授权
    IH_AliAuthSting, //支付宝授权
    IH_AliAuthorizationUserinfo,//获取支付宝用户信息
    IH_WithdrawCash,//提现
    IH_GetIncomeDetail,         // 根据userId获取收益明细
     IH_GetConsumDetail,         // 根据userId获取消费明细
    IH_GetApplyShare,   //分享功能
    IH_GetShareStatus,   //获取分享状态
    IH_getPictureWithUrl,              //开通邀请的图片
    IH_modeifyPassword,   //获取分享状态
    IH_GetInvatactionIncome,         // 根据userId获取邀请收益
    IH_GetPurseUser,//获取余额和总收益
    IH_GetMyIncomeCount,//获取邀请数
    IH_sendLoginVC,//验证码
    IH_User_Fastest_Login,//登录
    IH_SaveXc,
    IH_PostStoreJsInfo,      //管理员提交技师信息
    IH_jsTypeList, //技师种类
    IH_GetJsListByStoreId,//获取门店技师
    IH_DelSysJs,//删除技师
    IH_JSSort,//技师排序
    IH_HxOrderInfo,
    IH_Verification,//核销
    YJ_GetHomeData,//获取首页数据
    YJ_GetProjectManger,//获取项目管理
    IH_OrderMxListByStoreId,//核销记录
    YJ_GetItemType,//获取财务筛选类型
    YJ_GetStoreProject,//获取门店项目
    YJ_DeleStoreProject,//删除项目
    YJ_GetUserRole,//获取用户校色
    IH_DelSysFight,//删除拼团
    IH_SaveStoreInfo,//保存门店信息
     IH_getRoleId,//菜单角色
    IH_getStoreItem,//获取项目名称
    IH_addFghtGroupItem,//添加拼团项目
    IH_updateFghtGroupItem,//添加拼团项目
    IH_getStoreCoupon,
     IH_sendStoreCoupon,
    IH_getStoreNum,//获取门店短信数量
    IH_addStoreCoupon,
    IH_Nothing,
}IHFunctionTag;
