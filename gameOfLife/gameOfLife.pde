static final int W_WINDOW = 600;    //ウィンドウのサイズ
static final int H_WINDOW = 450;    //
static final int W_CELL = 10;   //セルのサイズ
static final int EDIT_MODE = 0; //modeがこの値の時に編集モードにする
static final int ANIMATION_MODE = 1;    //modeがこの値の時にアニメーションモードにする

int fps;    //fps

Cell[][] currentCells, nextCells;

int col, row;   //列、行の数
int mode;   //モード切替用変数
int info;   //情報の表示切替用変数
int generation; //世代を数えるための変数

PFont font;

//初めに実行する部分
void setup() {
    size(W_WINDOW, H_WINDOW);    //ウィンドウサイズを指定
    fps = 10;       //フレームレートのデフォルトは10      
    smooth();

    col = W_WINDOW / W_CELL;    //ウィンドウに収まる分だけ配列を用意
    row = H_WINDOW / W_CELL;
    currentCells = new Cell[col][row];
    nextCells = new Cell[col][row];
    for (int i = 0; i<col; i++) {
        for (int j=0; j<row; j++) {
            currentCells[i][j] = new Cell(i*W_CELL, j*W_CELL, W_CELL);
            nextCells[i][j] = new Cell(i*W_CELL, j*W_CELL, W_CELL);
        }
    }

    mode = EDIT_MODE;   //編集モードでスタートする
    generation = 1;     //世代は1から

    font = loadFont("UbuntuMono-Regular-48.vlw");   //フォントのロード
}

//ループ部分 
void draw() {
    frameRate(fps); //フレームレートの設定
    background(0);
    if (mode == ANIMATION_MODE) {   //次世代の生成
        nextGeneration();
        updateCells();
        generation++;   //世代をカウント
    }

    drawField();    //セルの描画

    if (info==1) {    //更新速度と世代の表示
        dispInfo();
    }
}

//クリック時のマウスの位置からセルを特定する
void mouseClicked() {
    if (mode == EDIT_MODE) {
        int locX = mouseX / W_CELL; //マウスの位置
        int locY = mouseY / W_CELL;
        //マウスの位置から特定されたセル
        Cell theCell = currentCells[locX][locY];
        int level = theCell.getLevel(); //セルの生死判定を得る

        //生死の切り替え
        if (level >= 1) {
            theCell.setLevel(0);
        }
        else {
            theCell.setLevel(1);
        }
    }
}

//キーをおした時の動作
void keyPressed() {
    //画面のクリア
    if (key == 'c') clearCell();
    //ランダムに初期化
    if (key == 'r') randomInit();
    //更新速度の操作
    if (key == 'h') fps = 10;
    if (key == 'l') fps = 60;
    if (key == 'k') fps += 2;
    if (key == 'j') {
        fps -= 2;
        if (fps <= 1) fps = 1;
    }
    //編集モードとアニメーションモードの切替
    if (key == ' ') {
        if (mode == ANIMATION_MODE) {
            mode = EDIT_MODE;
        }
        else if (mode == EDIT_MODE) {
            mode = ANIMATION_MODE;
        }
    }
    //情報表示の切替
    if (key == 'i') {
        if ( info == 0) {
            info = 1;
        }
        else if (info == 1) {
            info = 0;
        }
    }
    //アプリケーションの終了
    if (key == 'q') exit();
}

//セルのクリア
void clearCell() {
    for (int i=0; i<col; i++) {
        for (int j=0; j<row; j++) {
            currentCells[i][j].setLevel(0);
            nextCells[i][j].setLevel(0);
        }
    }
}

//ランダムに初期化する
void randomInit() {
    for (int i=1; i<col-1; i++) {
        for (int j=1; j<row-1; j++) {
            int r = (int)(random(0, 2));
            if (r==0) {
                currentCells[i][j].setLevel(0);
            }
            else {
                currentCells[i][j].setLevel(1);
            }
        }
    }
    generation = 1;
}

//更新速度、世代の情報を表示する
void dispInfo() {
    fill(255, 0, 0);
    textFont(font, 15);
    text("FPS : " + fps, 10, 15);
    text("Generation : " + generation, 10, 30);
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
            currentCells[i][j].setLevel(nextCells[i][j].getLevel());
        }
    }
}

//ルールに従って次世代を生成して、nextCells()に格納する
//(外周を除く部分を判定する。外周部分は常に死んでいる。)
void nextGeneration() {
    for (int i=1; i<col-1; i++) {
        for (int j=1; j<row -1; j++) {
            int level = currentCells[i][j].getLevel();
            int count = countAliveCell(i, j);

            if (level == 0) {   //セルが死んでいる時
                if (count == 3) {
                    nextCells[i][j].setLevel(1);    //セルが生まれる
                }
            }
            else {
                if (count >=4 || count <= 1) {
                    nextCells[i][j].setLevel(0);    //過密・過疎で死滅
                }
                else {
                    nextCells[i][j].setLevel(level + 1);    //生存(レベル＋１)
                }
            }
        }
    }
}

//周囲の生きているセルの数を返す
int countAliveCell(int i, int j) {
    int count = 0;

    if (currentCells[i-1][j-1].getLevel() >=1) count++;
    if (currentCells[i  ][j-1].getLevel() >=1) count++;
    if (currentCells[i+1][j-1].getLevel() >=1) count++;
    if (currentCells[i-1][j  ].getLevel() >=1) count++;
    if (currentCells[i+1][j  ].getLevel() >=1) count++;
    if (currentCells[i-1][j+1].getLevel() >=1) count++;
    if (currentCells[i  ][j+1].getLevel() >=1) count++;
    if (currentCells[i+1][j+1].getLevel() >=1) count++;

    return count;
}

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

