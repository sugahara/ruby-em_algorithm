# Gaussian Mixture Model Approximation by EMAlgorithm
EMアルゴリズムを用いて観測データの分布を混合ガウス分布で近似することができます．

EMアルゴリズムの終了判定は対数尤度の収束から判断し，デフォルトではステップごとの対数尤度の差が0.01未満になった時に収束とみなします．



## 使い方
    % ruby main.rb <input_file>

## ファイルフォーマット
### 入力ファイル
\<input_file>には一行に一つの値が入ったテキストファイルを指定します．

### 出力
EMアルゴリズムのステップごとに現在の尤度と各ガウス分布のパラメータが標準出力に出力されます．前述の終了判定を満たした時点でその時点での推定値からgnuplotで分布を描画するためのコマンドを標準出力に出力します．

## サンプル
### ボックス＝ミュラー法による生成
gaussディレクトリにボックス＝ミュラー法により生成された二混合ガウス分布データgmm.txtが存在する．（混合比[0,7, 0.3], 平均値[5.0, -5.0], 分散値[16.0, 1.0]）
実行方法

    % ruby main.rb gauss/gmm.txt

以下によりさらに異なるサンプルも作成可能．

    % ruby gauss/boxmuller.rb > gmm.txt

### Ruby/GSLによる生成

    % ruby gauss/gmm_gsl.rb

こちらでも生成可能

## EMアルゴリズムの各種パラメータ設定方法
###EMアルゴリズムの初期値について
EMアルゴリズムの推定結果は初期値に大きく依存するため，適切な初期値を設定することが望まれる．
ここで初期値とは推定する混合ガウス分布の混合数と各々の混合比，平均値，分散値である．
本プログラムは初期値の設定補助としてEMDataクラスを生成する際に第二引数を指定しなかった場合，混合比，平均値を混合数や入力データからランダムに設定する機能を搭載しているが，複雑な分布の近似の場合適切な値を得ることが困難なため，使用者によるマニュアル設定が必要である．


###初期値のマニュアル設定
初期値のマニュアル設定は以下に示す方法によって行う．

    % main.rb
    % em_data = EMData.new(data_array, initial_value)
	
の直前に以下のようなHashを作成する．

    initial_value = {
      :gamma => [0.5,0.5], # 混合比
      :mu => [0.0,10.0],   # 平均値
      :sigma2 => [9.0,9.0] # 分散値
    }

混合比は値の総和が1.0となるよう設定しなければならない．
混合数は:muの配列サイズから自動的に取得される．

##実際の度数分布の確認
入力データの実際の度数分布を確認するために以下のようにしてヒストグラム描画データを出力することができる．

    % ruby histogram.rb <input_file> <binsize> [<from> <to>] > <output_file>

[\<from>, \<to>]にはヒストグラムの描画範囲を指定することができる．

これにより出力されたデータをgnuplotで以下のように読みこめば良い．

    % gnuplot
    % >plot <output_file> using 1:3 w boxes;
