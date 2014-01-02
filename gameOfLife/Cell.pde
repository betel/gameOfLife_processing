class Cell {
    final int maxLevel = 11;

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
            fill(0, 150, 0);    //深緑
        }
        else if (level == 2) {  //黄緑
            fill(100, 255, 0);
        }
        else if (level == 3) {  //黄
            fill(255, 255, 0);
        }
        else if (level == 4) {  //橙
            fill(255, 100, 0);
        }
        else if (level == 5) {  //赤
            fill(255, 0, 0);
        }
        else if (level == 6) {  //桃
            fill(255, 0, 255);
        }
        else if (level == 7) {  //紫
            fill(100, 0, 255);
        }
        else if (level == 8) {  //青
            fill(0, 0, 255);
        }
        else if (level == 9) {  //水色
            fill(0, 100, 255);
        }
        else if (level == 10) { //シアン
            fill(0, 255, 255);
        }
        else if (level == 11) { //白
            fill(200);
        }
        else {
            fill(255);    //level==0、つまり死んでいる時
        }

        stroke(255);  //グリッド線
//        noStroke();
        rect(x, y, w, w);
//        ellipse(x, y, w, w);
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

