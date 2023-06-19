/***
# Install all dependencies:
sudo apt-get update
sudo apt-get -y install git build-essential libglib2.0-dev dkms xorg xorg-dev cpufrequtils net-tools linux-headers-$(uname -r) meld apt-transport-https cmake libboost-all-dev
# LLVM
sudo bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"
# Eigen
cd ~/Downloads
wget -q http://bitbucket.org/eigen/eigen/get/3.3.7.tar.bz2
tar -xf 3.3.7.tar.bz2
cd eigen*
mkdir build && cd build
cmake ..
sudo make install
sudo ln -s /usr/local/include/eigen3/Eigen /usr/local/include/Eigen
sudo ln -s /usr/local/include/eigen3/unsupported /usr/local/include/unsupported
# Pinnochio
sudo apt install -qqy lsb-release gnupg2 curl
echo "deb [arch=amd64] http://robotpkg.openrobots.org/packages/debian/pub $(lsb_release -cs) robotpkg" | sudo tee /etc/apt/sources.list.d/robotpkg.list
curl http://robotpkg.openrobots.org/packages/debian/robotpkg.key | sudo apt-key add -
sudo apt-get update
sudo apt install -qqy robotpkg-py27-pinocchio
echo #Pinnochio >> ~/.bashrc
echo export PATH=/opt/openrobots/bin:$PATH >> ~/.bashrc
echo export PKG_CONFIG_PATH=/opt/openrobots/lib/pkgconfig:$PKG_CONFIG_PATH >> ~/.bashrc
echo export LD_LIBRARY_PATH=/opt/openrobots/lib:$LD_LIBRARY_PATH >> ~/.bashrc
echo export PYTHONPATH=/opt/openrobots/lib/python2.7/site-packages:$PYTHONPATH >> ~/.bashrc
echo export CMAKE_PREFIX_PATH=/opt/openrobots:$CMAKE_PREFIX_PATH >> ~/.bashrc
echo export C_INCLUDE_PATH=/opt/openrobots/include:$C_INCLUDE_PATH >> ~/.bashrc
echo export CPLUS_INCLUDE_PATH=/opt/openrobots/include:$CPLUS_INCLUDE_PATH >> ~/.bashrc

# compile this file
clang++-10 -std=c++11 -o pinnochioPrinter.exe pinnochioPrinter.cpp -O3 -DPINOCCHIO_URDFDOM_TYPEDEF_SHARED_PTR -DPINOCCHIO_WITH_URDFDOM -lboost_system -L/opt/openrobots/lib -lpinocchio -lurdfdom_model -lpthread
***/

#include <stdio.h>
#include <cstring>
#include <random>
#include <vector>
#include <numeric>
#include <algorithm>
#define RANDOM_MEAN 0
#define RANDOM_STDEV 1
std::default_random_engine randEng(1337); // fixed seed
std::normal_distribution<double> randDist(RANDOM_MEAN, RANDOM_STDEV); //mean followed by stdiv
template <typename T>
T getRand(){return static_cast<T>(randDist(randEng));}

#define BOOST_BIND_GLOBAL_PLACEHOLDERS // fixes a warning I get

#include "pinocchio/spatial/fwd.hpp"
#include "pinocchio/spatial/se3.hpp"
#include "pinocchio/multibody/visitor.hpp"
#include "pinocchio/multibody/model.hpp"
#include "pinocchio/multibody/data.hpp"
#include "pinocchio/algorithm/joint-configuration.hpp"
#include "pinocchio/algorithm/kinematics.hpp"
#include "pinocchio/algorithm/kinematics-derivatives.hpp"
#include "pinocchio/algorithm/rnea-derivatives.hpp"
#include "pinocchio/algorithm/aba-derivatives.hpp"
#include "pinocchio/algorithm/crba.hpp"
#include "pinocchio/algorithm/centroidal.hpp"
#include "pinocchio/algorithm/aba.hpp"
#include "pinocchio/algorithm/rnea.hpp"
#include "pinocchio/algorithm/cholesky.hpp"
#include "pinocchio/algorithm/jacobian.hpp"
#include "pinocchio/algorithm/center-of-mass.hpp"
#include "pinocchio/algorithm/compute-all-terms.hpp"
#include "pinocchio/algorithm/kinematics.hpp"
#include "pinocchio/parsers/urdf.hpp"
#include "pinocchio/parsers/sample-models.hpp"
#include "pinocchio/container/aligned-vector.hpp"

#include <stdlib.h>
#include <iostream>
#include <fstream>
#include <sstream>
#include <sys/time.h>

#define EIGEN_DEFAULT_TO_ROW_MAJOR
#include <Eigen/Dense>
#include <Eigen/StdVector>
EIGEN_DEFINE_STL_VECTOR_SPECIALIZATION(Eigen::VectorXd)

using namespace Eigen;

class ReferenceHelper {
    pinocchio::Model model;
    std::string urdf_filepath;
    VectorXd q,qd,qdd,u;
    MatrixXd Minv;
    VectorXd tau_rnea;
    MatrixXd drnea_dq,drnea_dv,drnea_da;
    MatrixXd dqdd_dq,dqdd_dqd;

public:
    ReferenceHelper(std::string urdf_filepath);
    //==== INPUTS ====
    float * get_x_ref();
    float * get_qdd_ref();
    // returns negative of minv
    float * get_minv_ref();
    //==== OUTPUTS ====
    float * get_cdq_ref();
    float * get_cdqd_ref();
};

ReferenceHelper::ReferenceHelper(std::string urdf_filepath) {
    pinocchio::urdf::buildModel(urdf_filepath, model);
    model.gravity.setZero();
    pinocchio::Data data = pinocchio::Data(model);

    // allocate and load point on CPU
    q = VectorXd::Zero(model.nq);
    qd = VectorXd::Zero(model.nv);
    qdd = VectorXd::Zero(model.nv);
    u = VectorXd::Zero(model.nv);
    for(int j = 0; j < model.nq; j++){q[j] = getRand<double>(); if(j < model.nv){qd[j] = getRand<double>(); u[j] = getRand<double>();}}

    std::cout << "q,qd,u" << std::endl;
    std::cout << q.transpose() << std::endl;
    std::cout << qd.transpose() << std::endl;
    std::cout << u.transpose() << std::endl;

    // compute qdd and Minv
    pinocchio::computeMinverse(model,data,q);
    Minv = data.Minv; 
    Minv.template triangularView<Eigen::StrictlyLower>() = Minv.transpose().template triangularView<Eigen::StrictlyLower>();

    std::cout << "Minv" << std::endl << Minv << std::endl;

    tau_rnea = pinocchio::rnea(model,data,q,qd,qdd); // inverse dyanmics with qdd loaded in as 0 for bias term

    std::cout << "tau_rnea" << std::endl << tau_rnea.transpose() << std::endl;

    qdd = Minv * (u - tau_rnea);

    std::cout << "qdd" << std::endl << qdd.transpose() << std::endl;

    // print temps computed during those comps
    for(int i = 0; i < model.inertias.size(); i++){std::cout << "Inertia terms [" << i << "]" << std::endl << model.inertias[i] << std::endl;}
    for(int i = 0; i < data.liMi.size(); i++){std::cout << "X terms [" << i << "]" << std::endl << data.liMi[i] << std::endl;}
    
    // compute gradient first of RNEA
    drnea_dq = MatrixXd::Zero(model.nq,model.nq);
    drnea_dv = MatrixXd::Zero(model.nv,model.nv);
    drnea_da = MatrixXd::Zero(model.nv,model.nv);
    pinocchio::computeRNEADerivatives(model,data,q,qd,0*qdd,drnea_dq,drnea_dv,drnea_da);

    // // this also recomputes vaf that we note but its wrong -- seems only like v is kind of in the right frame
    // for(int i = 0; i < data.v.size(); i++){std::cout << "v [" << i << "]" << std::endl << data.v[i] << std::endl;}
    // for(int i = 0; i < data.a.size(); i++){std::cout << "a [" << i << "]" << std::endl << data.a[i] << std::endl;}
    // for(int i = 0; i < data.f.size(); i++){std::cout << "f [" << i << "]" << std::endl << data.a[i] << std::endl;}
    std::cout << "dRNEA_dq qdd=0" << std::endl << drnea_dq << std::endl;
    std::cout << "dRNEA_dqd qdd=0" << std::endl << drnea_dv << std::endl;

    pinocchio::computeRNEADerivatives(model,data,q,qd,qdd,drnea_dq,drnea_dv,drnea_da);

    std::cout << "dRNEA_dq qdd as computed above" << std::endl << drnea_dq << std::endl;
    std::cout << "dRNEA_dqd qdd as computed above" << std::endl << drnea_dv << std::endl;

    // then of dqdd
    dqdd_dq = MatrixXd::Zero(model.nv,model.nq);
    dqdd_dqd = MatrixXd::Zero(model.nv,model.nv);
    dqdd_dq = -Minv*drnea_dq;
    dqdd_dqd = -Minv*drnea_dv;

    std::cout << "dqdd_dq" << std::endl << dqdd_dq << std::endl;
    std::cout << "dqdd_dqd" << std::endl << dqdd_dqd << std::endl;
}

float * ReferenceHelper::get_x_ref() {
    VectorXd x(q.size() + qd.size());
    x << q, qd;
    VectorXf xf = x.cast<float>();

    // transposing because col-major by default, we need row-major
    VectorXf xf_rmaj = xf.transpose();
    size_t x_size = xf_rmaj.size() * sizeof(float);

    float * x_cpy = (float *)malloc(x_size);
    memcpy(x_cpy, xf_rmaj.data(), x_size);
    return x_cpy;
}

float * ReferenceHelper::get_qdd_ref() {
    VectorXf qddf = qdd.cast<float>();

    VectorXf qddf_rmaj = qddf.transpose();
    size_t qdd_size = qddf_rmaj.size() * sizeof(float);

    float * qdd_cpy = (float *)malloc(qdd_size);
    memcpy(qdd_cpy, qddf_rmaj.data(), qdd_size);
    return qdd_cpy;
}

float * ReferenceHelper::get_minv_ref() {
    MatrixXf minvf = Minv.cast<float>();
    minvf = -minvf;
    std::cout << "minv negative" << std::endl << minvf << std::endl;

    MatrixXf minvf_rmaj = minvf.transpose();
    size_t minv_size = minvf_rmaj.size() * sizeof(float);

    float * minv_cpy = (float *)malloc(minv_size);
    memcpy(minv_cpy, minvf_rmaj.data(), minv_size);
    return minv_cpy;
}

float * ReferenceHelper::get_cdq_ref() {
    MatrixXf dqdd_dqf = dqdd_dq.cast<float>();
    // transpose because rbd-accel outputs transpose of actual result
    MatrixXf dqdd_dqft = dqdd_dqf.transpose();
    std::cout << "dqdd_dq transpose" << std::endl << dqdd_dqft << std::endl;

    MatrixXf dqdd_dqft_rmaj = dqdd_dqft.transpose();
    size_t dqdd_dq_size = dqdd_dqft_rmaj.size() * sizeof(float);

    float * dqdd_dq_cpy = (float *)malloc(dqdd_dq_size);
    memcpy(dqdd_dq_cpy, dqdd_dqft_rmaj.data(), dqdd_dq_size);
    return dqdd_dq_cpy;
}

float * ReferenceHelper::get_cdqd_ref() {
    MatrixXf dqdd_dqdf = dqdd_dqd.cast<float>();
    MatrixXf dqdd_dqdft = dqdd_dqdf.transpose();
    std::cout << "dqdd_dqd transpose" << std::endl << dqdd_dqdft << std::endl;

    MatrixXf dqdd_dqdft_rmaj = dqdd_dqdft.transpose();
    size_t dqdd_dqd_size = dqdd_dqdft_rmaj.size() * sizeof(float);

    float * dqdd_dqd_cpy = (float *)malloc(dqdd_dqd_size);
    memcpy(dqdd_dqd_cpy, dqdd_dqdft_rmaj.data(), dqdd_dqd_size);
    return dqdd_dqd_cpy;
}
