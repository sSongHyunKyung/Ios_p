
# 何をしたいかをちゃんと考えてしよう！
! ViewContorllerのlifeCycleをちゃんと勉強するべき！
#・流る整理 

１．DB設定
　 ・openDB
　 ・create,insert tbl(login_tbl, employee_tbl, position_tbl, team_tbl) or VO 作成
　 ・CSVdata insert
　    - CSVdata 読み込む
　    - CSVdata insert

2. Login画面
　　・画面layout
　　・バリデーションチェック
　　・DBのIDとPWがあったら次の画面で移動
　　　 - loginIDでPWをselectするselect関数実装(例えばloginidがnilならばnilをreturn)
　
３．社員一覧画面
　　・画面layout
　　  - TableView
　　  - select(employee,position,team)関数実装
　　  - Cellに社員のDBの情報表示
　　  - Cellを押したら社員情報画面で移動
　
４．社員情報修正画面
　　・画面layout
　　　 - SrollView機能実装
　　　 - StackView機能実装
　　　 - Label,TextField
　　　 - RadioBtn機能実装
　　　 - PickerView機能実装（いろんな条件がある）
　　　 - Switch機能実装
　　　 - TextView
　　　 - KeyboardがTextFiled or TextViewを隠れた時の問題を解決する機能実装
　　・修正機能実装
　　　 - updateDB関数実装
　　　 - バリデーションチェック
　　　 - updateDBをDBに堂録

５．入力画面
　　・入力画面layout(修正画面でほとんど同じ)
 　　 - checkBax追加
 　　 - Scrollの終にはinsertbtn2が見えるべき
　　・入力機能実装
　 　 - まず社員番号を自動生成する関数実装
　 　 - insertDB関数実装（login,employee）
　 　 - radioBtn, chexbaxBtn機能確認
　　  - バリデーションチェック
　　  - 確認画面で移動
　　  
6. 内容確認画面
　　・確認画面layout
　　  - 入力画面の情報を表示
　　・堂録機能実装
　　  - insertDBをDBに堂録
　　  - 社員一覧画面に移動(一覧画面には情報がreloadするべき、入力がめん戻れば入力画面が新しいもので出る)
 
７．WebView
    ・WebViewlayout
    ・ネビガイションbar機能実装
     - 上でScrollをすればbarが出る下でScrollをすればbarが隠れる
　　　- Backbtn,Prebtn,reload btn 機能実装

 
