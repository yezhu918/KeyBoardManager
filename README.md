# YHKeyBoardManager
/**
 * --管理键盘确保不遮挡输入框
 * 注：
 * 1. TextField TextView 必须在一个scollerView上
 * 2. TextField.delegate设置 必须在managerTextField调用前(否则功能失效)
 * 3. UITextView.delegate设置 必须在managerTextView调用前(否则功能失效)
 */

/**
 *  例:
 *   KeyBoardManager * keyBoardManager = [[HKKeyBoardManager alloc]initWithScollerView:scrollerView];
 *   [keyBoardManager managerTextField:textField];
 *   [keyBoardManager managerTextField:textView];
 */
