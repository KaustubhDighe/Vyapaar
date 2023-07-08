#include <iostream>
#include <cmath>
#include <cstdlib>
using namespace std;

double cordic_atan(double y, double x) {
    if(x < 0) return ((y > 0) ? M_PI : -M_PI) + cordic_atan(-y, -x);
    double theta = 0.00;
    int i = 0;
    while(abs(y) > 10e-6) {
        double alpha = y >= 0 ? -1.00 : 1.00;
        double x_new = x - alpha * y * pow(2, -i);
        double y_new = y + alpha * x * pow(2, -i);
        x = x_new;
        y = y_new;
        theta = theta - alpha * atan(pow(2, -i));
        i++;
        // cout << i << ' ' << y << endl;
    }
    return theta;
}

double K(int n) {
    double x = 1.00;
    for(int i = 0; i < n; i++) {
        x /= sqrt(1 + pow(2, -2*i));
    }
    return x;
}

pair<double, double> cordic_sine(double theta) {
    if(theta > M_PI_2) {
        pair<double, double> res = cordic_sine(theta - M_PI);
        return make_pair(-res.first, -res.second);
    } else if(theta < -M_PI_2) {
        pair<double, double> res = cordic_sine(theta + M_PI);
        return make_pair(-res.first, -res.second);
    }
    double x = 1.00, y = 0.00;
    int i = 0;
    while(abs(theta) > 10e-6) {
        double alpha = theta >= 0 ? 1.00 : -1.00;
        double x_new = x - alpha * y * pow(2, -i);
        double y_new = y + alpha * x * pow(2, -i);
        x = x_new;
        y = y_new;
        theta = theta - alpha * atan(pow(2, -i));
        i++;
    }
    return make_pair(x * K(i), y * K(i));
}

int main() {
    cout << cordic_atan(1, 1) << ' ' << atan2(1, 1) << endl;
    cout << cordic_atan(1, 2) << ' ' << atan2(1, 2) << endl;
    cout << cordic_atan(2, 1) << ' ' << atan2(2, 1) << endl;
    cout << cordic_atan(-1, 1) << ' ' << atan2(-1, 1) << endl;
    cout << cordic_atan(1, -1) << ' ' << atan2(1, -1) << endl;
    cout << cordic_atan(-1, -1) << ' ' << atan2(-1, -1) << endl;

    cout << cordic_sine(M_PI_4).first << ' ' << cos(M_PI_4) << endl;
    cout << cordic_sine(M_PI_2).first << ' ' << cos(M_PI_2) << endl;
    cout << cordic_sine(M_PI/6).first << ' ' << cos(M_PI/6) << endl;
    cout << cordic_sine(M_PI/3).first << ' ' << cos(M_PI/3) << endl;
    cout << cordic_sine(-M_PI_2).second << ' ' << sin(-M_PI_2) << endl;
    cout << cordic_sine(-M_PI/3).second << ' ' << sin(-M_PI/3) << endl;
    cout << cordic_sine(-2*M_PI/3).second << ' ' << sin(-2*M_PI/3) << endl;
    cout << cordic_sine(2*M_PI/3).first << ' ' << cos(2*M_PI/3) << endl;

    for(int i = 0; i < 16; i++) {
        printf("  assign scaling[%d] = 16'h%06x;\n", i, (int) (pow(2, 13) * K(i)));
    }
}
