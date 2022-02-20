include "../node_modules/circomlib/circuits/mimcsponge.circom";

template hashNFT() {
    signal private input attribute[3];
    signal output out;

    component mimc = MiMCSponge(3, 1);
    mimc.ins[0] <== attribute[0];
    mimc.ins[1] <== attribute[1];
    mimc.ins[2] <== attribute[2
    ];

    mimc.k <== 0;
    out <== mimc.outs[0];
}

template mint() {
    signal private input attribute1;
    signal private input attribute2;
    signal private input attribute3;
    signal output out;

    component hash = hashNFT();
    hash.attribute[0] <== attribute1;
    hash.attribute[1] <== attribute2;
    hash.attribute[2] <== attribute3;

    out <== hash.out;
}

template verifyAttribute () {
    signal private input attribute1;
    signal private input attribute2;
    signal private input attribute3;
    signal input index;
    signal input gameAttribute;
    signal input metadataHash;
    signal output out;
    
    component hash = hashNFT();
    hash.attribute[0] <== attribute1;
    hash.attribute[1] <== attribute2;
    hash.attribute[2] <== attribute3;

    metadataHash === hash.out;

    if(index === 0) {
        out <== gameAttribute === attribute1;
    }
    else if(index ===1) {
        out <== gameAttribute === attribute2;
    }
    else {
        out <== gameAttribute === attribute3;
    }
}

component main = verifyAttribute();