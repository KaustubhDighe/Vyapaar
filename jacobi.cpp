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

// a = R{t x p}
// covariance = R{p x p}
vector<vector<double> > covariance(vector<vector<double> > a) {
    int t = a.size(), p = a[0].size();
    vector<vector<double> > q(p, vector<double>(p, 0.00));
    
    vector<double> mean(p, 0.00);
    for(int time = 0; time < t; time++) {
        for(int i = 0; i < p; i++) {
            mean[i] += a[time][i];
        }
    }
    for(int i = 0; i < p; i++) {
        mean[i] /= t;
    }
    
    for(int i = 0; i < p; i++) {
        for(int j = 0; j < p; j++) {
            for(int time = 0; time < t; time++) {
                q[i][j] += (a[time][i] - mean[i]) * (a[time][j] - mean[j]);
            }
            q[i][j] /= (t - 1);
        }
    }
    return q;
}

void update_moving_covariance(vector<vector<double> > &cov, vector<double> &mean, vector<double> &x, int &time, double lambda) {
    if(time == 1) {
        for(int i = 0; i < mean.size(); i++) {
            mean[i] = x[i];
        }
        time = time + 1;
        return;
    }
    for(int i = 0; i < cov.size(); i++) {
        for(int j = 0; j < cov[i].size(); j++) {
            cov[i][j] = (1-lambda) * cov[i][j] + (mean[i] - x[i]) * (mean[j] - x[j]) * lambda;
        }
    }
    cout << cov[0][0] * 256 << endl;
    for(int i = 0; i < mean.size(); i++) {
        mean[i] = mean[i] * (1 - lambda) + x[i] * lambda;
        //cout << mean[i] << ' ';
    }
    //cout << endl;
    time = time + 1;
}

void update_covariance(vector<vector<double> > &cov, vector<double> &mean, vector<double> &x, int &time) {
    if(time == 1) {
        for(int i = 0; i < mean.size(); i++) {
            mean[i] = x[i];
        }
        time = time + 1;
        return;
    }
    for(int i = 0; i < cov.size(); i++) {
        for(int j = 0; j < cov[i].size(); j++) {
            cov[i][j] = (time-2) * cov[i][j] / (time - 1) + (mean[i] - x[i]) * (mean[j] - x[j]) / time;
        }
    }
    for(int i = 0; i < mean.size(); i++) {
        mean[i] = (mean[i] * (time - 1) + x[i]) / time;
    }
    time = time + 1;
}

vector<vector<double> > incremental_covariance(vector<vector<double> > a) {
    int t = a.size(), p = a[0].size();
    int time = 1;

    vector<vector<double> > cov(p, vector<double>(p, 0.00));
    vector<double> mean(p);
    for(int i = 0; i < t; i++) {
        update_moving_covariance(cov, mean, a[i], time, 0.25);
    }
    return cov;
}

void print(vector<vector<double> > A) {
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

/**
 * @brief Rotate D with Jacobi rotation along columns and rows i, j
 * Q gets updated as a matrix of eigenvectors
 * 
 * D_new = J D J' => eventually D = J_k ... J_1 A J_1' ... J_k'
 * A = J_1' ... J_k' D J_k .. J_1
 * So should eventually be J_1' .. J_k' and at this step, Q_new = Q J'
 * J = all zeros, but J[k][k] = 1 for k != i, j 
 * J[i][i] = J[j][j] = cos(theta) J[j][i] = -sin(theta) = -J[i][j]
 */
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

void test_eigendecompose() {
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

    A[0][0] = 2.00, A[0][1] = 3.00, A[1][0] = 3.00, A[1][1] = 4.00;
    eigendecompose(A, Q, D);
    print(Q);
    print(D);
}

void test_covariance() {
    vector<vector<double> > a(6, vector<double>(2));
    a[0][0] = 0.00, a[0][1] = 3.00;
    a[1][0] = 1.00, a[1][1] = 3.00;
    a[2][0] = 2.00, a[2][1] = 3.00;
    a[3][0] = 3.00, a[3][1] = 3.00;
    a[4][0] = 4.00, a[4][1] = 3.00;
    a[5][0] = 5.00, a[5][1] = 3.00;
    print(covariance(a));
    print(incremental_covariance(a));


    a[0][0] = 0.00, a[0][1] = 3.00;
    a[1][0] = 1.00, a[1][1] = 5.00;
    a[2][0] = 2.00, a[2][1] = -3.00;
    a[3][0] = 3.00, a[3][1] = 1.00;
    a[4][0] = 4.00, a[4][1] = 9.00;
    a[5][0] = 5.00, a[5][1] = 3.00;
    print(covariance(a));
    print(incremental_covariance(a));
}

// testcases
int main() {
    // test_eigendecompose();
    test_covariance();
}