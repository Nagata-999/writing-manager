# Writing Manager

生徒の作文提出と教師の添削管理を行うシンプルなWebアプリです。

## v1
- 生徒：クラス・番号・氏名・課題を選択して作文提出
- 英文 word count
- 教師：提出一覧、課題/クラス/状態フィルター
- Content / Organization / Vocabulary / Grammar とコメント
- 添削済・返却済ステータス
- Supabase + vanilla HTML/CSS/JS

## セットアップ
1. Supabaseで **新しい専用プロジェクト** を作成します。
2. SQL Editorで `supabase.sql` を実行します。
3. Project Settings > API の Project URL と anon/publishable key を `config.js` に設定します。
4. `service_role` / secret key は絶対に `config.js` に入れないでください。
5. GitHub Pages等で公開します。

## セキュリティ上の重要事項
現在のRLSは匿名ユーザーに「課題一覧の閲覧」と「作文の新規提出」だけを許可しています。そのため生徒が他人の作文一覧を取得することはできません。

`teacher.html` の一覧取得・添削更新は、教師ログインを実装するまでRLSによって拒否されます。教師画面を動かすためにRLSを無効化したり、service_role keyをブラウザへ入れたりしないでください。次の実装ステップは Supabase Auth を使った教師認証です。

## ファイル
- `index.html` 生徒提出画面
- `teacher.html` 教師管理画面
- `app.js` 生徒側処理
- `teacher.js` 教師側処理
- `styles.css` 共通UI
- `config.js` Supabase接続設定
- `supabase.sql` DB作成SQL
