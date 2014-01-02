class Cell {
    final int maxLevel = 7;

    int x, y;   //セルの位置
    int w;  //セルの一辺の長さ  
    int level;

    //コンストラクタ
    Cell(int x, int y, int w) {
        this.x = x;
        this.y = y;
        this.w = w;
        level = 0;  //最初は死んだ状態
    }

    //セルの描画
    void drawCell() {
        if (level == 1) {   //セルの生存期間によって色を分ける
            fill(0, 150, 0);
        }
        else if (level == 2) {
            fill(100, 255, 0);
        }
        else if (level == 3) {
            fill(255, 255, 0);
        }
        else if (level == 4) {
            fill(255, 100, 0);
        }
        else if (level == 5) {
            fill(255, 0, 0);
        }
        else if (level == 6) {
            fill(255, 0, 255);
        }
        else if (level == 7) {
            fill(255, 255, 255);
        }
        else {
            fill(0);    //level==0、つまり死んでいる時
        }

        stroke(0);  //グリッド線は黒色
        rect(x, y, w, w);
        // ellipse(x, y, w, w);
    }

    //セルの寿命を設定する
    void setLevel(int l) {
        level = l;
        if (level>=maxLevel) {
            level = maxLevel;   //レベルはmaxLevelまで
        }
    }

    //セルの寿命を返す
    int getLevel() {
        return level;
    }
}
