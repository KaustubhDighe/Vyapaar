#include <iostream>
#include <vector>
#include <cmath>
#include <cstdlib>
using namespace std;

vector<vector<double> > multiply(vector<vector<double> > &a, vector<vector<double> > &b) {
    vector<vector<double> > c(a);
    int n = a.size();
    for(int i = 0; i < n; i++) {
        for(int j = 0; j < n; j++) {
            for(int k = 0; k < n; k++) {
                c[i][j] += a[i][k] * b[k][j];
            }
        }
    }
    return c;
}

void print(vector<vector<double> > &A) {
    for(int i = 0; i < A.size(); i++) {
        for(int j = 0; j < A.size(); j++) {
            cout << ((abs(A[i][j]) >= 0.0001) ? A[i][j] : 0) << ' ';
        }
        cout << endl;
    }
    cout << endl;
}

pair<int, int> max_off_diagonal(vector<vector<double> > &a) {
    int i_max = -1, j_max = -1;
    double max_val = INT64_MIN;
    for(int i = 0; i < a.size(); i++) {
        for(int j = 0; j < a.size(); j++) {
            if(i == j) continue;
            // symmetric matrix
            if(a[i][j] >= max_val) {
                max_val = a[i][j];
                i_max = i;
                j_max = j;
            }
        }
    }
    return make_pair(i_max, j_max);
}

bool converge(vector<vector<double> > &a) {
    double off_diag_norm = 0.00;
    for(int i = 0; i < a.size(); i++) {
        for(int j = i+1; j < a.size(); j++) {
            off_diag_norm += a[i][j] * a[i][j]; 
        }
    }
    return off_diag_norm < 0.0000001;
}

void jacobi(vector<vector<double> > &D, vector<vector<double> > &Q, int i, int j) {
    double theta = (D[i][i] == D[j][j]) ? M_PI/4 : atan(2 * D[i][j] / (D[j][j] - D[i][i])) / 2;
    double s = sin(theta), c = cos(theta);
    
    double new_Dii = c * c * D[i][i] - 2 * s * c * D[i][j] + s * s * D[j][j];
    double new_Djj = s * s * D[i][i] + 2 * s * c * D[i][j] + c * c * D[j][j];
    double new_Dij = (c*c - s*s) * D[i][j] + s * c * (D[i][i] - D[j][j]);
    
    vector<double> new_Dik(Q.size()), new_Djk(Q.size());
    for(int k = 0; k < Q.size(); k++) {
        if(k == i  || k == j) continue;
        new_Dik[k] = c * D[i][k] - s * D[j][k];
        new_Djk[k] = s * D[i][k] + c * D[j][k];
    }

    D[i][i] = new_Dii;
    D[j][j] = new_Djj;
    D[i][j] = new_Dij;
    D[j][i] = new_Dij;
    for(int k = 0; k < Q.size(); k++) {
        if(k == i  || k == j) continue;
        D[i][k] = new_Dik[k];
        D[k][i] = new_Dik[k];
        D[j][k] = new_Djk[k];
        D[k][j] = new_Djk[k];
    }

    /* D_new = J D J'
        Eventually D = J_k ... J_1 A J_1' ... J_k'
        A = J_1' ... J_k' D J_k .. J_1
        So should eventually be J_1' .. J_k'
        At this step, Q_new = Q J'
        J = all zeros, but J[k][k] = 1 for k != i, j
        J[i][i] = J[j][j] = cos(theta)
        J[j][i] = -sin(theta) = -J[i][j]
    */

    vector<double> new_Qki(Q.size()), new_Qkj(Q.size());
    for(int k = 0; k < Q.size(); k++) {
        new_Qki[k] = c * Q[k][i] - s * Q[k][j];
        new_Qkj[k] = s * Q[k][i] + c * Q[k][j];
    }
    
    for(int k = 0; k < Q.size(); k++) {
        Q[k][i] = new_Qki[k];
        Q[k][j] = new_Qkj[k];
    }
}

// A = QDQ'
void eigendecompose(vector<vector<double> > &A, vector<vector<double> > &Q, vector<vector<double> > &D) {
    int n = A.size();
    
    // Initialize D to A and Q to identity
    D = A;
    for(int i = 0; i < n; i++)
        for(int j = 0; j < n; j++) 
            Q[i][j] = (i == j) ? 1.00 : 0.00;
    //print(Q);


    while(!converge(D)) {
        pair<int, int> pivot = max_off_diagonal(D);
        //cout << pivot.first << ' ' << pivot.second << endl;
        jacobi(D, Q, pivot.first, pivot.second);
        // print(Q);
    }
}

int main() {
    vector<vector<double> > A(2, vector<double>(2));
    A[0][0] = 4.00, A[0][1] = 0.00, A[1][0] = 0.00, A[1][1] = 3.00;
    vector<vector<double> > Q = A, D = A;
    eigendecompose(A, Q, D);
    print(Q);
    print(D);

    A[0][0] = 2.00, A[0][1] = 3.00, A[1][0] = 3.00, A[1][1] = 2.00;
    eigendecompose(A, Q, D);
    print(Q);
    print(D);
}