static final int W_WINDOW = 600;    //ウィンドウのサイズ
static final int H_WINDOW = 450;    //
static final int W_CELL = 15;   //セルのサイズ
static final int EDIT_MODE = 0; //modeがこの値の時に編集モードにする
static final int ANIMATION_MODE = 1;    //modeがこの値の時にアニメーションモードにする

Cell[][] currentCells, nextCells;

int col, row;   //列、行の数
int mode;   //モード切替用変数

//初めに実行する部分
void setup() {
    size(W_WINDOW, H_WINDOW);    //ウィンドウサイズを指定
    frameRate(10);	//フレームレートの設定	
    col = W_WINDOW / W_CELL;	//ウィンドウに収まる分だけ配列を用意
    row = H_WINDOW / W_CELL;
    currentCells = new Cell[col][row];
    nextCells = new Cell[col][row];
    for (int i = 0; i<col; i++) {
        for (int j=0; j<row; j++) {
            currentCells[i][j] = new Cell(i*W_CELL, j*W_CELL, W_CELL);
            nextCells[i][j] = new Cell(i*W_CELL, j*W_CELL, W_CELL);
        }
    }
    mode = EDIT_MODE;
}

//ループ部分	
void draw() {
    if (mode == ANIMATION_MODE) {
        nextGeneration();
        updateCells();
    }
    drawField();
}

//クリック時のマウスの位置からセルを特定する
void mouseClicked() {
    if (mode == EDIT_MODE) {
        int locX = mouseX / W_CELL;
        int locY = mouseY / W_CELL;
        Cell theCell = currentCells[locX][locY];	//マウスの位置から特定されたセル
        boolean life = theCell.getBool();	//セルの生死判定を得る

        //生死の切り替え
        if (life) {
            theCell.setBool(false);
        }
        else {
            theCell.setBool(true);
        }
    }
}

//キーをおした時の動作
void keyPressed() {
    if (key == 'c') {
        clearCell();
    }
    if (key == ' ') {
        if (mode == ANIMATION_MODE) {
            mode = EDIT_MODE;
        }
        else if (mode == EDIT_MODE) {
            mode = ANIMATION_MODE;
        }
    }
    if (key == 'q') {
        exit();
    }
}

//セルのクリア
void clearCell() {
    for (int i=0; i<col; i++) {
        for (int j=0; j<row; j++) {
            currentCells[i][j].setBool(false);
        }
    }
}

//全てのセルを描画する
void drawField() {
    for (int i=0; i<col; i++) {
        for (int j=0; j<row; j++) {
            currentCells[i][j].drawCell();
        }
    }
}

//次世代の内容を現在のセルにコピー
void updateCells() {
    for (int i=0; i<col; i++) {
        for (int j=0; j<row; j++) {
            currentCells[i][j] = nextCells[i][j];
        }
    }
}

//ロジック部分（判定するのは外周を除く部分）
//ルールに従って次世代を生成して、nextCells()に格納する
void nextGeneration() {
    for (int i=1; i<col-1; i++) {
        for (int j=1; j<row -1; j++) {
            boolean life = currentCells[i][j].getBool();
            if (!life) {	//セルが死んでいる時
                if (countAliveCell(i, j) == 3) {
                    nextCells[i][j].setBool(true);	//セルが生まれる
                }
            }
            else {
                if (countAliveCell(i, j) >=4) {
                    nextCells[i][j].setBool(false);	//過密により死滅
                }
                else if (countAliveCell(i, j) >= 2) {
                    nextCells[i][j].setBool(true);	//生存
                }
                else {
                    nextCells[i][j].setBool(false);	//過疎により死滅
                }
            }
        }
    }
}

//周囲の生きているセルの数を返す
int countAliveCell(int i, int j) {
    int count = 0;

    if (currentCells[i-1][j-1].getBool()) count++;
    if (currentCells[i][j-1].getBool()) count++;
    if (currentCells[i+1][j-1].getBool()) count++;
    if (currentCells[i-1][j].getBool()) count++;
    if (currentCells[i+1][j].getBool()) count++;
    if (currentCells[i-1][j+1].getBool()) count++;
    if (currentCells[i][j+1].getBool()) count++;
    if (currentCells[i+1][j+1].getBool()) count++;

    return count;
}

class Cell {
    final int GREEN;
    final int GRAY;
    final int RED;	//テスト用

    int x, y;	//セルの位置
    int w;	//セルの一辺の長さ	
    boolean life;	//セルの生死(false=dead, true=alive)

    //コンストラクタ
    Cell(int x, int y, int w) {
        this.x = x;
        this.y = y;
        this.w = w;
        GREEN = color(0, 255, 0);
        GRAY = color(80);
        RED = color(255, 0, 0);
    }

    //セルの描画
    void drawCell() {
        if (life) {	//セルの生死によって色を分ける
            fill(GREEN);
        }
        else {
            fill(GRAY);
        }

        stroke(0);	//グリッド線は黒色
        rect(x, y, w, w);
    }

    //セルの生死を設定する
    void setBool(boolean life) {
        this.life = life;
    }

    //セルの生死を返す
    boolean getBool() {
        return life;
    }
}

