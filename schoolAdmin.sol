// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

//Le debut du contrat intelligent
contract manageSchool {
    //On declare une variable "proprio" de type adresse => prorietaire
    address proprio;

    //On declare une structure "cote" avec diverses variables qui lui seront utiles
    struct cote {
        string sujet;
        uint point;
    }

    //On declare une structure "eleve" avec diverses variables qui lui seront utiles

    struct eleve {
        string nom;
        string prenom;
        uint nbreDeCotes;

        //On fait une liaison entre eleve et cotes. Comme ça on pourra savoir de quel eleve appartient une cote
        mapping (uint => cote) cotes;
    }

    //Un mapping general entre l'adresse de connexion de l'eleve et l'eleve entant que structure de donnees
    mapping (address => eleve) eleves;

    //constructeur
    constructor () {
        proprio = msg.sender;
    } 

    modifier isOwner {
        require(msg.sender == proprio, "Vous n'etes pas le proprio");
        _;
    }

    function addEleve (address _eleveAdress, string memory _nom, string memory _prenom) public isOwner {
        bytes memory verifyELeve = bytes(eleves[_eleveAdress].prenom);
        require (verifyELeve.length == 0, "L'eleve existe deja");

        eleves [_eleveAdress].nom = _nom;
        eleves [_eleveAdress].prenom = _prenom;
    }

    function addCote (address _eleveAdress, string memory _sujet, uint _point) public isOwner {
        bytes memory verifyELeve = bytes(eleves[_eleveAdress].prenom);
        require (verifyELeve.length > 0, "L'eleve existe deja");

        eleves[_eleveAdress].cotes[eleves[_eleveAdress].nbreDeCotes].point = _point;
        eleves[_eleveAdress].cotes[eleves[_eleveAdress].nbreDeCotes].sujet = _sujet;

        eleves[_eleveAdress].nbreDeCotes ++;
    }

    function getCotes (address _eleveAdress) public view isOwner returns(uint[] memory) {
        bytes memory verifyELeve = bytes(eleves[_eleveAdress].prenom);
        require (verifyELeve.length > 0, "L'eleve existe deja");

        uint cptr = eleves[_eleveAdress].nbreDeCotes;
        uint [] memory tableau = new uint [] (cptr);

        for (uint i =0; i < cptr; i++) {
            tableau [i] = eleves[_eleveAdress].cotes[i].point;
        }

        return tableau;
    }

}