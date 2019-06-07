/*
 * REMEPP
 * Description:  Remplissage de l'espace de pratiques Plage des pertuis charentais en saison estivale
 *  Concepteurs :  
 */

model REMEPP

global {
	/////////////defintion des couleurs des entites //////////////////
	rgb couleur_cellule_en_recherche <- #blue;
	rgb couleur_cellule_installe <- #red;
	rgb couleur_mer <- #lightblue;
	rgb couleur_arriere_plage_urbaine<- rgb(192,192,192);
	rgb couleur_arriere_plage_sauvage<- rgb (98,150,80);
	rgb couleur_arriere_plage_sable<- #tan;
	rgb couleur_parking <-#silver;
	rgb couleur_rocher <-#grey;
	rgb couleur_sable_mouille <-#burlywood;
	rgb couleur_milieu_plage<- rgb(246,224,140);
	rgb couleur_haut_plage<- rgb(246,224,140);
	rgb couleur_bas_plage<- rgb(246,224,140);
	rgb couleur_coquillages<- rgb(247,223,217);
	rgb couleur_algues<- rgb(183,219,100);
	rgb couleur_galets<- rgb(227,218,243);
	rgb couleur_zone_proxi_baignade<- rgb(236,216,155);
	rgb couleur_zone_baignade<- rgb(rgb (48, 163, 157,255));
	font fontTexteHautDeCarte1 <- font("SansSerif",20,#bold);
	font fontTexteHautDeCarte2 <- font("SansSerif",20,#plain);
	font fontTexteHautDeCarte3 <- font("SansSerif",16,#plain);

	///////// parametres de distance/////
	float dist_saut <- 15°m;
	float rayon_prospection <- 15°m;
	string methode_installation <- "Au plus loin des autres"; // "Au hasard",  "Au plus loin des autres" "Au plus près des autres"
	string texte_heure_mn_s<-"";
	string texte_heure_mn_moins15;
	string texte_heure_mn<-"";
	float distance_inter_cellules_peu_de_place <- 0.3°m;//0.3°m;
	float distance_inter_cellules_moyennement_de_place <- 2.3°m;//2.3°m;
	float distance_inter_cellules_beaucoup_de_place <- 5.3°m;//5.3°m;
	string zone_pour_distance_inter_cellules_variable <- "inactif";
	float rayon_secteur_a_l_entree_pour_distance_intercellules_variable <- 200°m;
	float rayon_perception_densite_environnante <- 30°m;
	float seuil_espace_dispo_peu<-20°m2;
	float seuil_espace_dispo_beaucoup <- 40°m2;
	bool activer_distance_inter_cellules_pour_marcheurs<- true;
	float distance_inter_cellules_pour_marcheurs <- 12°m;
	
	//////export des résultats//////
	string export_csv <- "../export/cellules_valeurs";
	string export_shp<- "../export/cellules";
	string export_csv_pop_initiale<- "../export/pop_initiale";
	
	//////// Import des fichiers  ////////
	file shape_grille_20_20 ;
	file shape_secteur;
	file shape_entree ;
	file shape_zone ;
	file shape_element;
	file shape_fond;
 	file shape_fleche;
 	
	string type_plage<-"support 02 plage sauvage";	
	string population<- "Population type Gros-Jonc";
	string configuration_plage<-"support 02 plage sauvage";
	string rythme<-"rythme02";
	geometry shape;
	bool afficher_zone_prospectee;
	bool afficher_segments;
	string aspect_cellule;
	string type_couleur_cellule;
	int tot_satisf <-0;
	geometry segment_haut_plage;
	geometry segment_milieu_plage;  
	geometry segment_bas_plage;
	geometry segment_zone_baignade; 
	geometry zone_haut;
	geometry zone_milieu;
	geometry zone_bas;
	geometry zone_sable;
	geometry zone_proxi_baignade; 
	geometry zone_algue;
	geometry zone_coquillage;
	geometry zone_galet;
	float step<-30°sec;
	entree mon_entree;
	
	int nb_cellules_init <- 400;
	int nb_cellules_entree<-0;
	int nb_personnes_entree<-0;
	int nb_cellules_entree_ds_quart_heure;
	int nb_cellules_entree_ds_quart_heure2;	
	int cumul_nb_cellules_entree<-0;
	int cumul_nb_cellules_sortie<-0;
	int cumul_nb_personnes_entree<-0;
	int cumul_nb_personnes_sortie<-0;
	bool export<- false;
	string affichage_chemin_parcouru;
	int time_to_pause<-0;
	
	//////Variables des indicateurs de sorties//////
	int percSatisf1;
	int percSatisf2;
	int percSatisf3;
	int percSatisf4;
	int percSatisf5;
	float tranchesQuartHeure;
	int H <- 0;
	int MN <- 0;
	int S <- 0;
	int QH <- 0;
	int percMaille_PeuEspace<-0;
	int percMaille_MoyenEspace<-0;
	int percMaille_BeaucoupEspace<-0;
	
	//////Légende de la couleur des Cellules//////
	map<string,rgb> couleur_par_enfant <- ["ado"::rgb(56,171,65), "avec":: rgb(199,122,175), "sans":: rgb(206,158,68)];
	map<string,rgb> couleur_par_statut <- ["touriste"::#limegreen, "excursionniste":: #silver, "resident_secondaire":: #darksalmon,"local":: #darkblue];
	map<string,rgb> couleur_par_taille <- [1::rgb(74,98,171), 2::rgb(46,164,222), [3,5]::rgb(186,111,60), [6,8]::rgb(150,23,36), [9,10]::rgb(150,23,164)];
	map<string,rgb> couleur_par_env <- ["faible"::#red, "fort":: #limegreen, "neutre":: #burlywood];
	map<string,rgb> couleur_par_pref_zone <- ["haut"::#limegreen, "bas":: #darksalmon, "neutre":: #silver,"zone baignade"::#darkblue];
	map<string,rgb> couleur_par_espace_dispo_environnant <- ["peu":: #lightcoral, "moyen"::#burlywood,"beaucoup"::#limegreen,"marcheur"::#darkblue];
	map<string,rgb> couleur_par_satisfaction <- ["[0 à 4]"::rgb(255,0,0), "[5 à 9]"::rgb(231,120,43), "[10 à 13]"::rgb(247,168,67), "[14 à 17]"::rgb(140,186,98), "[18 à 20]"::rgb(5,136,55)];
			


	init {
		do import_fichiers_support;	
		time <- 36000;
		do update_heure;
		if type_plage ="support 02 plage sauvage" {
						 if configuration_plage ="plage nettoyee"{
			 	 shape_element <- file("../includes/elements_support02.shp");
			 }
			 else{
			 	if configuration_plage="plage partiellement nettoyee"{
			 		shape_element <- file("../includes/elements_support02_partie_nettoye.shp");	
			 	}
			 	else{
			 		shape_element <- file("../includes/elements_support02_non_nettoye.shp");
			 	}
			 }
			 }
		if type_plage ="support 02 plage sauvage"   {
			 create element from: shape_element with: [type::string(read ("type_elem"))] ;
			 zone_proxi_baignade <- element first_with (each.type="zone_proxi_baignade"); 
			 segment_zone_baignade <-  first(file("../includes/segment_zone_baignade_supp_02.shp")); 
			 } 
		create zone from: shape_zone with: [type::string(read ("type_zones"))] {do init;}
				
		create entree from: shape_entree with:[num_entree::int(read("Id")), nom_entree::string(read("nom_entree"))] ;
		
		create maille_20_20 from: shape_grille_20_20
			{
				surface <- self.shape.area;   
			}
		create secteur from: shape_secteur with:[num_entree::int(read("entree")), direction::string(read("secteur"))]; 
		if type_plage ="support 01 plage urbaine"{ask secteur where (each.num_entree = 1 and each.direction = "droite") {do die;}}
		
		if type_plage="support 01 plage urbaine"   {
			segment_haut_plage <-geometry(file("../includes/segment_haut_plage_supp_01.shp")) ;
			segment_milieu_plage <-geometry(file("../includes/segment_milieu_plage_supp_01.shp")) ;
	    	segment_bas_plage <- geometry(file("../includes/segment_bas_plage_supp_01.shp")); 		
		}
		if  type_plage= "support 02 plage sauvage"  {
			segment_haut_plage <-geometry(file("../includes/segment_haut_plage_supp_02.shp")) ;
			segment_milieu_plage <-geometry(file("../includes/segment_milieu_plage_supp_02.shp")) ;
	    	segment_bas_plage <- geometry(file("../includes/segment_bas_plage_supp_02.shp")); 		
		}
	
		create segment from: [segment_haut_plage,segment_milieu_plage,segment_bas_plage];

        zone_haut<-union (zone where (each.type="haut_plage"));
		zone_milieu<-union (zone where (each.type="milieu_plage"));
		zone_bas<- union(zone where (  each.type="bas_plage" ));
		zone_sable <-  (union([zone_haut,  zone_milieu , zone_bas]));
		zone_algue<- union (element where (each.type="algues"));
		zone_coquillage<- union(element where (each.type="coquillages"));
		zone_galet<- union(element where (each.type="galets"));

			create cellule number:nb_cellules_init  
				{
				location <-{0,0};
				do init_cellule;
				}
			/// initialisation des heures d'arrivee des cellules en fontion du rythme_dentree /////////////////
			float rythme_dentree <-0.0;
			list<float> list_rythme <-[];
			list<list<float>> list_dure_instal <-[];
	
			/// *** Parametrage des rythmes ******///////////
			if rythme="rythme01"{
					list_rythme <- [1,1,2,1,1,1,1,1,1,1,1,2.2,3,3,4,5,5,5,4,5,4,5,5,4,3,3,3,3,4,4,4.4,2	,3.2,2.2,1,1,0,0,0,0];
					list_dure_instal <- [[0.6,0.13,0.1,0.07,0.05,0.05],[0.6,0.13,0.1,0.07,0.05,0.05],[0.6,0.13,0.1,0.07,0.05,0.05],[0.6,0.13,0.1,0.07,0.05,0.05],[0.6,0.13,0.1,0.07,0.05,0.05] ,[0.6,0.13,0.1,0.07,0.05,0.05],[0.55,0.18,0.1,0.07,0.05,0.05],[0.55,0.18,0.1,0.07,0.05,0.05],[0.55,0.18,0.1,0.07,0.05,0.05],[0.55,0.18,0.1,0.07,0.05,0.05],[0.55,0.18,0.1,0.07,0.05,0.05],[0.55,0.18,0.1,0.07,0.05,0.05],[0.45,0.23,0.14,0.15,0.03,0],[0.45,0.23,0.14,0.15,0.03,0],[0.45,0.23,0.14,0.15,0.03,0],[0.45,0.23,0.14,0.15,0.03,0],[0.45,0.23,0.14,0.15,0.03,0],[0.25,0.33,0.24,0.15,0.03,0],[0.25,0.33,0.24,0.15,0.03,0],[0.25,0.33,0.24,0.15,0.03,0],[0.25,0.33,0.24,0.15,0.03,0],[0.25,0.33,0.24,0.15,0.03,0],[0.11,0.37,0.31,0.21,0,0],[0.11,0.37,0.31,0.21,0,0],[0.11,0.37,0.31,0.21,0,0],[0.21,0.37,0.31,0.11,0,0],[0.21,0.37,0.31,0.11,0,0],[0.21,0.37,0.31,0.11,0,0],[0.14,0.46,0.4,0,0,0],[0.14,0.46,0.4,0,0,0],[0.14,0.46,0.4,0,0,0],[0.14,0.46,0.4,0,0,0],[0.24,0.76,0,0,0,0],[0.24,0.76,0,0,0,0],[0.24,0.76,0,0,0,0],[0.24,0.76,0,0,0,0],[1,0,0,0,0,0],[1,0,0,0,0,0],[1,0,0,0,0,0],[1,0,0,0,0,0]];
				}
			if rythme="rythme02"{
					list_rythme <- [1.0,2.3,2.4,3.0,2.1,3.9,4.7,4.2,3.8,5.5,3.8,2.2,0.6,0.8,2.4,2.6,4.2,4.3,6.1,4.5,3.3,4.9,4.5,3.0,3.8,3.7,1.4,1.6,1,3.0,0.6,0.8,0.0,2.2,0.8,1.0,0.0,0.0,0.0,0.0];
					list_dure_instal <- [[0.6,0.13,0.1,0.07,0.05,0.05],[0.6,0.13,0.1,0.07,0.05,0.05],[0.6,0.13,0.1,0.07,0.05,0.05],[0.6,0.13,0.1,0.07,0.05,0.05],[0.6,0.13,0.1,0.07,0.05,0.05],[0.6,0.13,0.1,0.07,0.05,0.05],[0.55,0.18,0.1,0.07,0.05,0.05],[0.55,0.18,0.1,0.07,0.05,0.05],[0.55,0.18,0.1,0.07,0.05,0.05],[0.55,0.18,0.1,0.07,0.05,0.05],[0.55,0.18,0.1,0.07,0.05,0.05],[0.55,0.18,0.1,0.07,0.05,0.05],[0.21,0.23,0.28,0.19,0.09,0],[0.21,0.23,0.28,0.19,0.09,0],[0.21,0.23,0.28,0.19,0.09,0],[0.21,0.23,0.28,0.19,0.09,0],[0.21,0.23,0.28,0.19,0.09,0],[0.14,0.33,0.31,0.19,0.03,0],[0.14,0.33,0.31,0.19,0.03,0],[0.14,0.33,0.31,0.19,0.03,0],[0.14,0.33,0.31,0.19,0.03,0],[0.14,0.33,0.31,0.19,0.03,0],[0.11,0.37,0.31,0.21,0,0],[0.11,0.37,0.31,0.21,0,0],[0.11,0.37,0.31,0.21,0,0],[0.21,0.37,0.31,0.11,0,0],[0.21,0.37,0.31,0.11,0,0],[0.21,0.37,0.31,0.11,0,0],[0.46,0.14,0.39,0,0,0],[0.46,0.14,0.39,0,0,0],[0.46,0.14,0.39,0,0,0],[0.46,0.14,0.39,0,0,0],[0.24,0.76,0,0,0,0],[0.24,0.76,0,0,0,0],[0.24,0.76,0,0,0,0],[0.24,0.76,0,0,0,0],[1,0,0,0,0,0],[1,0,0,0,0,0],[1,0,0,0,0,0],[1,0,0,0,0,0]];
				}
	  		if  rythme="rythme test 1"{ /// les valeurs sont a remplacer par les nouvelles valeurs test
					list_rythme <- [1.0,2.3,2.4,3.0,2.1,3.9,4.7,4.2,3.8,5.5,3.8,2.2,0.6,0.8,2.4,2.6,4.2,4.3,6.1,4.5,3.3,4.9,4.5,3.0,3.8,3.7,1.4,1.6,1,0,3.0,0.6,0.8,0.0,2.2,0.8,1.0,0.0,0.0,0.0,0.0];
					list_dure_instal <- [[0.6,0.13,0.1,0.07,0.05,0.05],[0.6,0.13,0.1,0.07,0.05,0.05],[0.6,0.13,0.1,0.07,0.05,0.05],[0.6,0.13,0.1,0.07,0.05,0.05],[0.6,0.13,0.1,0.07,0.05,0.05],[0.6,0.13,0.1,0.07,0.05,0.05],[0.55,0.18,0.1,0.07,0.05,0.05],[0.55,0.18,0.1,0.07,0.05,0.05],[0.55,0.18,0.1,0.07,0.05,0.05],[0.55,0.18,0.1,0.07,0.05,0.05],[0.55,0.18,0.1,0.07,0.05,0.05],[0.55,0.18,0.1,0.07,0.05,0.05],[0.21,0.23,0.28,0.19,0.09,0],[0.21,0.23,0.28,0.19,0.09,0],[0.21,0.23,0.28,0.19,0.09,0],[0.21,0.23,0.28,0.19,0.09,0],[0.21,0.23,0.28,0.19,0.09,0],[0.14,0.33,0.31,0.19,0.03,0],[0.14,0.33,0.31,0.19,0.03,0],[0.14,0.33,0.31,0.19,0.03,0],[0.14,0.33,0.31,0.19,0.03,0],[0.14,0.33,0.31,0.19,0.03,0],[0.11,0.37,0.31,0.21,0,0],[0.11,0.37,0.31,0.21,0,0],[0.11,0.37,0.31,0.21,0,0],[0.21,0.37,0.31,0.11,0,0],[0.21,0.37,0.31,0.11,0,0],[0.21,0.37,0.31,0.11,0,0],[0.46,0.14,0.39,0,0,0],[0.46,0.14,0.39,0,0,0],[0.46,0.14,0.39,0,0,0],[0.46,0.14,0.39,0,0,0],[0.24,0.76,0,0,0,0],[0.24,0.76,0,0,0,0],[0.24,0.76,0,0,0,0],[0.24,0.76,0,0,0,0],[1,0,0,0,0,0],[1,0,0,0,0,0],[1,0,0,0,0,0],[1,0,0,0,0,0]];
				}
	  		if rythme="rythme test 2"{ /// les valeurs sont a remplacer par les nouvelles valeurs test
					list_rythme <- [1.0,2.3,2.4,3.0,2.1,3.9,4.7,4.2,3.8,5.5,3.8,2.2,0.6,0.8,2.4,2.6,4.2,4.3,6.1,4.5,3.3,4.9,4.5,3.0,3.8,3.7,1.4,1.6,1,0,3.0,0.6,0.8,0.0,2.2,0.8,1.0,0.0,0.0,0.0,0.0];
					list_dure_instal <- [[0.6,0.13,0.1,0.07,0.05,0.05],[0.6,0.13,0.1,0.07,0.05,0.05],[0.6,0.13,0.1,0.07,0.05,0.05],[0.6,0.13,0.1,0.07,0.05,0.05],[0.6,0.13,0.1,0.07,0.05,0.05],[0.6,0.13,0.1,0.07,0.05,0.05],[0.55,0.18,0.1,0.07,0.05,0.05],[0.55,0.18,0.1,0.07,0.05,0.05],[0.55,0.18,0.1,0.07,0.05,0.05],[0.55,0.18,0.1,0.07,0.05,0.05],[0.55,0.18,0.1,0.07,0.05,0.05],[0.55,0.18,0.1,0.07,0.05,0.05],[0.21,0.23,0.28,0.19,0.09,0],[0.21,0.23,0.28,0.19,0.09,0],[0.21,0.23,0.28,0.19,0.09,0],[0.21,0.23,0.28,0.19,0.09,0],[0.21,0.23,0.28,0.19,0.09,0],[0.14,0.33,0.31,0.19,0.03,0],[0.14,0.33,0.31,0.19,0.03,0],[0.14,0.33,0.31,0.19,0.03,0],[0.14,0.33,0.31,0.19,0.03,0],[0.14,0.33,0.31,0.19,0.03,0],[0.11,0.37,0.31,0.21,0,0],[0.11,0.37,0.31,0.21,0,0],[0.11,0.37,0.31,0.21,0,0],[0.21,0.37,0.31,0.11,0,0],[0.21,0.37,0.31,0.11,0,0],[0.21,0.37,0.31,0.11,0,0],[0.46,0.14,0.39,0,0,0],[0.46,0.14,0.39,0,0,0],[0.46,0.14,0.39,0,0,0],[0.46,0.14,0.39,0,0,0],[0.24,0.76,0,0,0,0],[0.24,0.76,0,0,0,0],[0.24,0.76,0,0,0,0],[0.24,0.76,0,0,0,0],[1,0,0,0,0,0],[1,0,0,0,0,0],[1,0,0,0,0,0],[1,0,0,0,0,0]];
	  		    }
	  		      
			loop i from: 0 to: length (list_rythme) - 1 {
	    	   rythme_dentree <-  list_rythme[i];
	    		int h <-  36000+ (i * 900);
	    		nb_cellules_entree<-round(nb_cellules_init*rythme_dentree/100);
	    		if nb_cellules_entree != 0 
		    	  { list<cellule> cellule_sans_heure_arrivee <- shuffle(cellule where (each.heure_arrivee = 0) ); 
		    		float p_1a2h <- list_dure_instal[i][0] ;
		    		float p_2a3h <- list_dure_instal[i][1] ;
		    		float p_3a4h <- list_dure_instal[i][2] ;
		    		float p_4a5h <- list_dure_instal[i][3] ;
		    		float p_5a6h <- list_dure_instal[i][4] ;
		    		float p_6a8h <- list_dure_instal[i][5] ;
					if (length (cellule_sans_heure_arrivee) < nb_cellules_entree)
						{	bool test<- true;
							loop ii from:(i+1) to:length (list_rythme) - 1 {if list_rythme[ii] != 0 {test<-false;}}
							if test {/*ca veut dire que c'est la dernière catégorie de rythme*/
										nb_cellules_entree <-length (cellule_sans_heure_arrivee);
							}
						}
					if (length (cellule_sans_heure_arrivee) >= nb_cellules_entree)
		    			{	 
						loop j from:0 to: nb_cellules_entree -1
							{
							cellule_sans_heure_arrivee[j].heure_arrivee <-(h+min([rnd(60*15),(60*15-int(step))]));//h;
							float tirage_alea <- rnd (1000)/1000 ;
							if tirage_alea  < p_1a2h {cellule_sans_heure_arrivee[j].duree_installation_prevue  <- 30 *(120 + rnd(120)) ; } 
							else {if tirage_alea  < (p_1a2h +p_2a3h) {cellule_sans_heure_arrivee[j].duree_installation_prevue <-  30 *(240 + rnd(120)) ; }
								else {if tirage_alea  < (p_1a2h +p_2a3h+p_3a4h) {cellule_sans_heure_arrivee[j].duree_installation_prevue <-  30 *(360 + rnd(120)) ; }
									else {if tirage_alea  < (p_1a2h +p_2a3h+p_3a4h+p_4a5h) {cellule_sans_heure_arrivee[j].duree_installation_prevue <-  30 *(480 + rnd(120)) ; }
										else {if tirage_alea  < (p_1a2h +p_2a3h+p_3a4h+p_4a5h+p_5a6h) {cellule_sans_heure_arrivee[j].duree_installation_prevue <-  30 *(600 + rnd(120)) ; }
											else {cellule_sans_heure_arrivee[j].duree_installation_prevue <-  30 *(720 + rnd(240)) ; }
											}
										}
									}
								}		
							}
						}
					else {write "Problème : cellule_sans_heure_arrivee ->" + length (cellule_sans_heure_arrivee) + "nb_cellules_entree"+ nb_cellules_entree;
							write "index " +i+ " sur " +  length (list_rythme);
					}	
				  }
				}
  	}
  	
  	////Importer les shapes-fichiers supports//////////////
  	action import_fichiers_support {
  		switch type_plage {
			match "support 01 plage urbaine" {
				shape_zone <- file("../includes/zone_support01_basPlage20m.shp");
				shape_entree <- file("../includes/entree_support01.shp");
				shape_secteur <- file("../includes/secteur_entree_support_01.shp");
				shape_grille_20_20 <-file("../includes/grille_20_20_support01.shp");
				shape <-  envelope(shape_zone);	
			}
			match "support 02 plage sauvage" {
				shape_element <- file("../includes/elements_support02.shp");
				shape_zone <- file("../includes/zone_support02_2.shp");
				shape_entree <- file("../includes/entree_support02.shp");
				shape_secteur <- file("../includes/secteur_entree_support_02.shp");
				shape_grille_20_20 <- file("../includes/grille_20_20_support02.shp");
				shape <-  envelope(shape_zone);	
			}
			
  		}
  	}
  	
  	int select_index_randomly_from_values_not_0 (list<float> aList) {
  		bool keep_looking <- true;
  		int i<-0;
  		int limit<-0;
		loop while: keep_looking
			{ 	i <- rnd (length(aList-1));
				if aList[i]!=0{keep_looking <- false;}
				limit<-limit+1;
				if limit = 1000 {break;}
			}
		if keep_looking {return -99999999;} else {return i;}
  	}
  	
	geometry add_point_nb (geometry aLine, point aPoint) {
		list<point> pp<- copy(aLine.points);
		add aPoint to: pp ;  
		return line(pp);
	}
	
	geometry remove_last_point (geometry aLine) {
		list<point> pp<- copy(aLine.points);
		remove index: (length(pp)-1) from: pp ;  
		return line(pp);
	}

	////Export de la pop initiale en csv//////////////
    reflex export_pop_initiale when: export !=false and cycle =0 {
		int i <-1;
		loop while:file_exists( export_csv_pop_initiale + i +".csv") {i <-i+1;}
		save 
			(  ['statut','taille','rayon_cercle_quand_installe','enfant','env','sociabilite','heure_arrivee','duree_installation_prevue','preference_position',
			'preference_zone_baignade','possibilite_marche','gene_coquillage','gene_galet','gene_algue',
			'appreciation_densite_par_plageur','appreciation_densite_par_plageur_initiale','sensibilite_sociabilite']  )
			
			to: export_csv_pop_initiale +i+ ".csv" type: "csv";
		ask cellule {
			save 
			( [statut,taille,rayon_cercle_quand_installe,enfant,env,sociabilite, heure_arrivee,duree_installation_prevue,preference_position,preference_zone_baignade,possibilite_marche,gene_coquillage,gene_galet,gene_algue,appreciation_densite_par_plageur,appreciation_densite_par_plageur_initiale,sensibilite_sociabilite] 	)
	   			to: export_csv_pop_initiale +i+ ".csv"
				type: "csv"
				rewrite:false;
	   		}
	   	}
	   				   		
    reflex a_faire_en_debut_de_cycle {
		if empty (cellule) {time_to_pause<- time_to_pause+1;}
		if time_to_pause=2 {do pause;}
		
		write "<<< cycle " + cycle +" >>>"; 
		write "------------";
		}    
 
	reflex update_nb_cellules_entree {
	nb_cellules_entree <-0;
	nb_personnes_entree <-0;
	}
	
	////Heure afficher sur la Simualtion//////////////
	reflex update_heure2 {do update_heure ;}
	
	action update_heure {
		H <- int(floor(time/3600));
		MN <- int(floor((int(time) mod 3600)/60));
		S <- ((int(time) mod 3600)mod 60) ;
		QH <- int(floor((int(time) /900)));
		texte_heure_mn_s <-""+H+"h "+ MN+"mn "+S +"s";
		texte_heure_mn <-""+H+"h"+ (MN=0?"00":MN);
		int mn_moins15 <- int(floor((int(time-900) mod 3600)/60));
		texte_heure_mn_moins15 <- ""+int(floor((time-900)/3600))+"h"+ (mn_moins15=0?"00":mn_moins15);
		tranchesQuartHeure <-0;
		if S = 0 {
			switch MN {
				match 0 {tranchesQuartHeure <-1;}
				match_one [15,30,45] { tranchesQuartHeure <-0.5;}
				}
			}
	}
	
	
	reflex update_a_chaque_quart_heure when: S = 30 and [0,15,30,45] contains MN {
		nb_cellules_entree_ds_quart_heure<-0;
		nb_cellules_entree_ds_quart_heure2<-0;
	}
	
	reflex update_a_chaque_quart_heure2 when: S = 0 and [0,15,30,45] contains MN {
		nb_cellules_entree_ds_quart_heure2<-nb_cellules_entree_ds_quart_heure;
	}
	
	reflex a_faire_en_fin_de_cycle {
		percMaille_PeuEspace <- 100* maille_20_20 count (each.categorie_espace_disponible_par_plageur = "peu") / length(maille_20_20) ;
		percMaille_MoyenEspace <- 100* maille_20_20 count (each.categorie_espace_disponible_par_plageur = "moyen") / length(maille_20_20) ;
		percMaille_BeaucoupEspace <- 100* maille_20_20 count (each.categorie_espace_disponible_par_plageur = "beaucoup") / length(maille_20_20) ;
	}
}

////Species//////////////
species zone{
	string type;
	rgb color;
	action init {
		switch type{
			match 'mer'{color<-couleur_mer;}
			match "arriere_plage"{color<-type_plage = "support 01 plage urbaine"? couleur_arriere_plage_urbaine:couleur_arriere_plage_sauvage;}
			match"haut_plage"{color<-couleur_haut_plage;}
			match"milieu_plage"{color<- couleur_milieu_plage;}
			match"bas_plage"{color<-couleur_bas_plage;}
			}
		}
	aspect base{
		draw shape color:color;
	}
}

species fond{
	rgb color;	
	string type;
	action charge_couleur {
		switch type{
			match 'mer'{color<-couleur_mer;}
			match "sable"{color<-couleur_arriere_plage_sable;}
			match"parking"{color<- couleur_parking;}
			match"foret"{color<-couleur_arriere_plage_sauvage;}
			match "rocher"{color <-couleur_rocher;}
			match "sable mouille" {color <-couleur_sable_mouille;}
			}
		}
	aspect base{
		draw shape color:color;
	}
}

species fleche{
	rgb color;	
	aspect base{
		draw shape color:#crimson;
	}
}

species segment    
	{
		aspect base {if afficher_segments{
			if self.shape = segment_bas_plage
			{
				draw shape color: #red;
			}
			else
			{
				draw shape color:#black;
			}
		}}
	}

species entree{
	rgb color <-#crimson;
	geometry shape <- triangle(4);
	int num_entree;
	string nom_entree;
	aspect base{
		draw shape color:color ;
	}
}

species maille_20_20 {
	int nb_cellules<-0;
	int nb_personnes<-0;
	float surface <- 0.0 ;
	float espace_disponible_par_plageur <-0;
	float densite <- 0;
	string categorie_espace_disponible_par_plageur;
	aspect base {
		draw shape color:#yellow;
		}
		
	reflex calcul_espace_disponible_par_plageur {
		nb_cellules<-0; nb_personnes<-0;
		ask (cellule where (each.etat =2) inside(self)) {
			myself.nb_cellules <- myself.nb_cellules+1;
			myself.nb_personnes<- myself.nb_personnes + taille;
		}
		if nb_personnes = 0 {espace_disponible_par_plageur <- surface;} else {espace_disponible_par_plageur <- surface / nb_personnes;}
		if espace_disponible_par_plageur < seuil_espace_dispo_peu {categorie_espace_disponible_par_plageur <- "peu";}
		else{if espace_disponible_par_plageur > seuil_espace_dispo_beaucoup {categorie_espace_disponible_par_plageur <- "beaucoup";}
			else {categorie_espace_disponible_par_plageur <- "moyen";}
		}
		densite <- 1 / espace_disponible_par_plageur;
	}
}

species secteur {
	int num_entree ;
	string direction;
	float densite<-0.0;
	int nb_personnes;
	
	reflex calcul_densite
	{
		nb_personnes<-0;
		ask (cellule where (each.etat =2) inside(self)) {
			myself.nb_personnes<- myself.nb_personnes + taille;
		}
		densite <- nb_personnes / self.shape.area;
	}
}
		
species element{
	string type;
	rgb color ;
	aspect base{
		switch type{
			match 'coquillages'{color<-couleur_coquillages;}
			match "algues"{color<-couleur_algues;}
			match"galets"{color<-couleur_galets;}
			match"zone_proxi_baignade"{color<-couleur_zone_proxi_baignade;}
			match"zone_baignade"{color<-couleur_zone_baignade;}
		}
		draw shape color:color;
	}
}
	
species cellule skills:[moving]{
	
	int taille<-1;// nb de personnes ds la cellule
	string env; // soit faible fort ou neutre
	string enfant; // soit "ado" soit "avec" soit "sans"
	string statut ; //touriste excursionniste resident_secondaire ou local 
	string sociabilite ;// fort ou neutre
	
	string preference_position;//haut,bas,neutre.
	string preference_zone_baignade<-"neutre"; //mns oui, ou mns neutre
	string pref_zone -> {preference_zone_baignade="neutre"?preference_position:"zone baignade"}; //Calculé à partir des deux précédents // haut,bas,neutre ou zone baignade
	string possibilite_marche;// peu, moyen ou beaucoup
	string gene_coquillage; // oui ou non
	string gene_galet; // oui ou non
	string gene_algue; // oui ou non
	string appreciation_densite_par_plageur; // apprecie densite fort ou moyen mais pas faible, ou, apprecie densite faible ou moyen mais pas fort
	string appreciation_densite_par_plageur_initiale;
	string sensibilite_sociabilite; // pref_centre_gravite, ou, pas_pref_centre_gravite
	
	float heure_arrivee<-0.0;
	int heure_installation<-0;  
	int duree_installation_prevue; 
	int satisfaction <-20; 
	int etat <- 0; // attend(0), déplacement (1), installé(2)
	int temps_ecoule;	

	float rayon_cercle_actuel <- rayon_cercle_quand_deplacement ;
	float rayon_cercle_quand_deplacement <- 0.3°m;
	float rayon_cercle_quand_installe;
	float distance_confort<- 0°cm;
	float distance_inter_cellules_variable <- 0°m;
	
	rgb color <- couleur_cellule_en_recherche ;
    geometry shape <- circle(rayon_cercle_actuel);
    point location_precedent ;
    point location_avant_installation;
	list<point> possible_loc;
	geometry zone_prospectee;
	geometry chemin_parcouru;
	
	int nb_sauts <- 0;
	int nb_sauts_effectifs <- 0;
	
	bool a_percu_coquillage <- false;
	bool a_percu_galet <- false;
	bool a_percu_algue <- false;
	bool a_deja_passe_seuil_des_40m <- false;
	bool a_deja_passe_seuil_des_100m <- false;
	float distance_parcourue<-0°m;
	entree mon_entree;
	bool installation_impossible_car_trop_dense  <- false;
	string espace_dispo_avant; //categorie_espace_disponible_par_plageur_maille_au_cycle_precedent
	string espace_dispo_environnant <-"";
	
 
	action init_cellule{
		speed <- dist_saut/step;
		heading <-90;

//// initialisation des profils des cellules (taille, enfants, statut....) /////////////////
  ////////*****paramétrage de la popualtion type Concurrence ******////
  if population="Population type Concurrence"{
	switch  rnd(100)/100
		{
		match_between [0 , 0.27] {taille <-1 ;}
		match_between [0.28,0.7] {taille <-2 ;} 
		match_between [0.71 , 0.88] {taille <-3 ;}
		match_between [0.88 , 0.96] {taille <-4 ;}
		match_between [0.97 , 0.98] {taille <-5 ;}
		match_between [0.99 , 1] {taille <-6 ;}		
		}
	if taille != 1 {if rnd(100)/100 < 0.07 {enfant <- "ado";}}
	if taille != 1 and enfant != "ado" {if rnd(100)/100 < 0.54 {enfant <- "avec";} else{enfant<-"sans";}}
	if taille=1{enfant<-"sans";}
	
	switch  rnd(100)/100
		{
		match_between [0 , 0.38] {env <- "faible" ;}
		match_between [0.39,0.92] {env <-"neutre" ;} 
		match_between [0.93 , 1] {env <- "fort";}
	 	}
		switch  rnd(100)/100
		{
		match_between [0 , 0.59] {statut <- 'touriste' ;}
		match_between [0.60,0.74] {statut <-'excursionniste' ;}
		match_between [0.75 , 0.80] {statut <- 'resident_secondaire';}
		match_between [0.81 , 1] {statut <- 'local';}
		}
		switch  rnd(100)/100{
		match_between [0 , 0.25] {sociabilite <- "fort" ;}
		match_between [0.26,1] {sociabilite <-"neutre" ;} 
		
		}
		
	}
	////////*****paramétrage de la popualtion type Gros-Jonc ******////
   if population="Population type Gros-Jonc"{
		switch  rnd(1000)/1000
		{
		match_between [0 , 0.079] {taille <-1 ;}
		match_between [0.080,0.369] {taille <-2 ;} 
		match_between [0.370 , 0.579] {taille <-3 ;}
		match_between [0.580 , 0.819] {taille <-4 ;}
		match_between [0.820 , 0.909] {taille <-5 ;}
		match_between [0.910 , 0.949] {taille <-6 ;}		
		match_between [0.950 , 0.969] {taille <-7 ;}
		match_between [0.970 , 0.979] {taille <-8 ;}	
		match_between [0.980 , 0.989] {taille <-9 ;}
		match_between [0.990 , 1] {taille <-10 ;}
		}
	if taille != 1 {if rnd(100)/100 < 0.08 {enfant <- "ado";}}
	if taille != 1 and enfant != "ado" {if rnd(100)/100 < 0.62 {enfant <- "avec";} else{enfant<-"sans";}}
	if taille=1{enfant<-"sans";}
	
	switch  rnd(100)/100
		{
		match_between [0 , 0.24] {env <- "faible" ;}
		match_between [0.25,0.82] {env <-"neutre" ;} 
		match_between [0.83 , 1] {env <- "fort";}
	 	}
		switch  rnd(100)/100
		{
		match_between [0 , 0.74] {statut <- 'touriste' ;}
		match_between [0.75,0.86] {statut <-'excursionniste' ;} 
		match_between [0.87, 0.94] {statut <- 'resident_secondaire';}
		match_between [0.95 , 1] {statut <- 'local';}
		
		}
		switch  rnd(100)/100{
		match_between [0 , 0.25] {sociabilite <- "fort" ;}
		match_between [0.26,1] {sociabilite <-"neutre" ;}
		
		}
	
	}
	////////*****paramétrage de la popualtion test 1 ******////
	if population="Population test 1"{
		switch  rnd(1000)/1000
		{
		match_between [0 , 0.079] {taille <-1 ;}
		match_between [0.080,0.369] {taille <-2 ;} 
		match_between [0.370 , 0.579] {taille <-3 ;}
		match_between [0.580 , 0.839] {taille <-4 ;}
		match_between [0.820 , 0.929] {taille <-5 ;}
		match_between [0.910 , 0.949] {taille <-6 ;}		
		match_between [0.950 , 0.969] {taille <-7 ;}
		match_between [0.970 , 0.979] {taille <-8 ;}	
		match_between [0.980 , 0.989] {taille <-9 ;}
		match_between [0.990 , 1] {taille <-10 ;}
		}
	if taille != 1 {if rnd(100)/100 < 0.08 {enfant <- "ado";}}
	if taille != 1 and enfant != "ado" {if rnd(100)/100 < 0.62 {enfant <- "avec";} else{enfant<-"sans";}}
	if taille=1{enfant<-"sans";}
	
	switch  rnd(100)/100
		{
		match_between [0 , 0.24] {env <- "faible" ;}
		match_between [0.25,0.82] {env <-"neutre" ;} 
		match_between [0.83 , 1] {env <- "fort";}
	 	}
		switch  rnd(100)/100
		{
		match_between [0 , 0.74] {statut <- 'touriste' ;}
		match_between [0.75,0.86] {statut <-'excursionniste' ;} 
		match_between [0.87, 0.94] {statut <- 'resident_secondaire';}
		match_between [0.95 , 1] {statut <- 'local';}
		
		}
		switch  rnd(100)/100{
		match_between [0 , 0.25] {sociabilite <- "fort" ;}
		match_between [0.26,1] {sociabilite <-"neutre" ;}
		
		}
	
	}
		////////*****paramétrage de la popualtion test 2 ***//// 
	if population="Population test 2"{
		switch  rnd(1000)/1000
		{
		match_between [0 , 0.079] {taille <-1 ;}
		match_between [0.080,0.369] {taille <-2 ;} 
		match_between [0.370 , 0.579] {taille <-3 ;}
		match_between [0.580 , 0.839] {taille <-4 ;}
		match_between [0.820 , 0.929] {taille <-5 ;}
		match_between [0.910 , 0.949] {taille <-6 ;}		
		match_between [0.950 , 0.969] {taille <-7 ;}
		match_between [0.970 , 0.979] {taille <-8 ;}	
		match_between [0.980 , 0.989] {taille <-9 ;}
		match_between [0.990 , 1] {taille <-10 ;}
		}
	if taille != 1 {if rnd(100)/100 < 0.08 {enfant <- "ado";}}
	if taille != 1 and enfant != "ado" {if rnd(100)/100 < 0.62 {enfant <- "avec";} else{enfant<-"sans";}}
	if taille=1{enfant<-"sans";}
	
	switch  rnd(100)/100
		{
		match_between [0 , 0.24] {env <- "faible" ;}
		match_between [0.25,0.82] {env <-"neutre" ;} 
		match_between [0.83 , 1] {env <- "fort";}
	 	}
		switch  rnd(100)/100
		{
		match_between [0 , 0.74] {statut <- 'touriste' ;}
		match_between [0.75,0.86] {statut <-'excursionniste' ;} 
		match_between [0.87, 0.94] {statut <- 'resident_secondaire';}
		match_between [0.95 , 1] {statut <- 'local';}
		
		}
		switch  rnd(100)/100{
		match_between [0 , 0.25] {sociabilite <- "fort" ;}
		match_between [0.26,1] {sociabilite <-"neutre" ;}
		
		}
	
	}
		
	//////Initiatlisation paramètres toutes populations/////
	if enfant="avec"{
			switch  rnd(100)/100
		{
		match_between [0 , 0.20] {preference_position <- "haut" ;}
		match_between [0.21,0.60] {preference_position<-"bas" ;} 
		match_between [0.61 , 1] {preference_position <- "neutre";}
		}
		}
		if enfant="sans"{
				switch  rnd(100)/100
		{
		match_between [0 , 0.25] {preference_position <- "haut" ;}
		match_between [0.26,0.50] {preference_position<-"bas" ;} 
		match_between [0.51 , 1] {preference_position <- "neutre";}
		  }
		}
		if enfant="ado"{
				switch  rnd(100)/100
		{
		match_between [0 , 0.40] {preference_position <- "haut" ;}
		match_between [0.41,0.55] {preference_position<-"bas" ;} 
		match_between [0.56, 1] {preference_position <- "neutre";}
		  }
		}
		if enfant="avec"{
			switch  rnd(100)/100
		{
		match_between [0 , 0.60] {preference_zone_baignade <- "oui" ;}
		match_between [0.61,1] {preference_zone_baignade<-"neutre" ;} 		
		}
		}
		if enfant="sans"{
				switch  rnd(100)/100
		{
		match_between [0 , 0.35] {preference_zone_baignade <- "oui" ;}
		match_between [0.36,1] {preference_zone_baignade<-"neutre" ;} 
		  }
		}
		if enfant="ado"{
				switch  rnd(100)/100
		{
		match_between [0 , 0.35] {preference_zone_baignade <- "oui" ;}
		match_between [0.36,1] {preference_zone_baignade<-"neutre" ;} 
		
		  }
		}
		if taille=1{
			if env="faible"{
			switch  rnd(100)/100
		{
		match_between [0 , 0.16] {possibilite_marche <- "peu" ;}
		match_between [0.17,0.69] {possibilite_marche<-"moyen" ;} 	
		match_between [0.70 , 1] {possibilite_marche <- "beaucoup" ;} 	
		}
		}
		if env="neutre"{
				switch  rnd(100)/100
		{
		match_between [0 , 0.17] {possibilite_marche <- "peu" ;}
		match_between [0.18,0.57] {possibilite_marche<-"moyen" ;} 	
		match_between [0.58 , 1] {possibilite_marche <- "beaucoup" ;}	
		  }
		}
		if env="fort"{
				switch  rnd(100)/100
		{
		match_between [0 , 0.08] {possibilite_marche <- "peu" ;}
		match_between [0.09,0.62] {possibilite_marche<-"moyen" ;} 	
		match_between [0.63 , 1] {possibilite_marche <- "beaucoup" ;}
		  }
		}
		}
		
		if taille=2{
			if env="faible"{
			switch  rnd(100)/100
		{
		match_between [0 , 0.28] {possibilite_marche <- "peu" ;}
		match_between [0.29,0.77] {possibilite_marche<-"moyen" ;} 	
		match_between [0.78 , 1] {possibilite_marche <- "beaucoup" ;} 
		}
		}
		if env="neutre"{
				switch  rnd(100)/100
		{
		match_between [0 , 0.27] {possibilite_marche <- "peu" ;}
		match_between [0.28,0.67] {possibilite_marche<-"moyen" ;} 	
		match_between [0.68 , 1] {possibilite_marche <- "beaucoup" ;}
		  }
		}
		if env="fort"{
				switch  rnd(100)/100
		{
		match_between [0 , 0.13] {possibilite_marche <- "peu" ;}
		match_between [0.14,0.69] {possibilite_marche<-"moyen" ;} 	
		match_between [0.70 , 1] {possibilite_marche <- "beaucoup" ;}
		  }
		}
		}
		
		if (taille=3 or taille =4 or taille=5)  {
			if env="faible"{
			switch  rnd(100)/100
		{
		match_between [0 , 0.27] {possibilite_marche <- "peu" ;}
		match_between [0.28,0.88] {possibilite_marche<-"moyen" ;} 	
		match_between [0.89 , 1] {possibilite_marche <- "beaucoup" ;} 
		}
		}
		if env="neutre"{
				switch  rnd(100)/100
		{
		match_between [0 , 0.28] {possibilite_marche <- "peu" ;}
		match_between [0.29,0.80] {possibilite_marche<-"moyen" ;} 	
		match_between [0.81 , 1] {possibilite_marche <- "beaucoup" ;}
		  }
		}
		if env="fort"{
				switch  rnd(100)/100
		{
		match_between [0 , 0.13] {possibilite_marche <- "peu" ;}
		match_between [0.14,0.82] {possibilite_marche<-"moyen" ;} 	
		match_between [0.83, 1] {possibilite_marche <- "beaucoup" ;}
		  }
		}
		}
		
			if (taille=6 or taille =7 or taille=8)  {
			if env="faible"{
			switch  rnd(100)/100
		{
		match_between [0 , 0.56] {possibilite_marche <- "peu" ;}
		match_between [0.57,0.89] {possibilite_marche<-"moyen" ;} 	
		match_between [0.90 , 1] {possibilite_marche <- "beaucoup" ;} 
		}
		}
		if env="neutre"{
				switch  rnd(100)/100
		{
		match_between [0 , 0.53] {possibilite_marche <- "peu" ;}
		match_between [0.54,0.81] {possibilite_marche<-"moyen" ;} 	
		match_between [0.82 , 1] {possibilite_marche <- "beaucoup" ;}
		  }
		}
		if env="fort"{
				switch  rnd(100)/100
		{
		match_between [0 , 0.33] {possibilite_marche <- "peu" ;}
		match_between [0.34,0.77] {possibilite_marche<-"moyen" ;} 	
		match_between [0.78, 1] {possibilite_marche <- "beaucoup" ;} 
		  }
		}
		}
		
		if (taille=9 or taille=10)  {
			if env="faible"{
			switch  rnd(100)/100
		{
		match_between [0 , 0.80] {possibilite_marche <- "peu" ;}
		match_between [0.81,1] {possibilite_marche<-"moyen" ;} 	
		}
		}
		if env="neutre"{
				switch  rnd(100)/100
		{
		match_between [0 , 0.77] {possibilite_marche <- "peu" ;}
		match_between [0.78,1] {possibilite_marche<-"moyen" ;} 	
		  }
		}
		if env="fort"{
				switch  rnd(100)/100
		{
		match_between [0 , 0.50] {possibilite_marche <- "peu" ;}
		match_between [0.51,1] {possibilite_marche<-"moyen" ;} 	
		  }
		}
		}
		

		if env="faible"{
			switch  rnd(100)/100
		{
		match_between [0 , 0.55] {gene_coquillage <- "oui" ;}
		match_between [0.56,1] {gene_coquillage<-"non" ;} 
		}
		}
		if env="neutre"{
				switch  rnd(100)/100
		{
		match_between [0 , 0.50] {gene_coquillage<- "oui" ;}
		match_between [0.51,1] {gene_coquillage<-"non" ;} 
		  }
		}
		if env="fort"{
				switch  rnd(100)/100
		{
		match_between [0 , 0.40] {gene_coquillage<- "oui" ;}
		match_between [0.41,1] {gene_coquillage<-"non" ;} 
		  }
		}
		
		if env="faible"{
			switch  rnd(100)/100
		{
		match_between [0 , 0.55] {gene_galet <- "oui" ;}
		match_between [0.56,1] {gene_galet<-"non" ;} 
		}
		}
		if env="neutre"{
				switch  rnd(100)/100
		{
		match_between [0 , 0.50] {gene_galet<- "oui" ;}
		match_between [0.51,1] {gene_galet<-"non" ;} 		
		  }
		}
		if env="fort"{
				switch  rnd(100)/100
		{
		match_between [0 , 0.40] {gene_galet<- "oui" ;}
		match_between [0.41,1] {gene_galet<-"non" ;} 
		  }
		}
		
		if env="faible"{
			switch  rnd(100)/100
		{
		match_between [0 , 0.60] {gene_algue <- "oui" ;}
		match_between [0.61,1] {gene_algue<-"non" ;} 
		}
		}
		if env="neutre"{
				switch  rnd(100)/100
		{
		match_between [0 , 0.50] {gene_algue<- "oui" ;}
		match_between [0.51,1] {gene_algue<-"non" ;} 
		  }
		}
		if env="fort"{
				switch  rnd(100)/100
		{
		match_between [0 , 0.45] {gene_algue<- "oui" ;}
		match_between [0.46,1] {gene_algue<-"non" ;} 
		  }
		}
		
		if env="faible"{
			switch  rnd(100)/100
		{
		match_between [0 , 0.20] {appreciation_densite_par_plageur <- "fort_moyen_pas_faible" ;}
		match_between [0.21,1] {appreciation_densite_par_plageur<-"faible_moyen_pas_fort" ;} 
		}
		}
		if env="neutre"{
				switch  rnd(100)/100
		{
		match_between [0 , 0.12] {appreciation_densite_par_plageur<- "fort_moyen_pas_faible" ;}
		match_between [0.13,1] {appreciation_densite_par_plageur<-"faible_moyen_pas_fort" ;} 	
		  }
		}
		if env="fort"{
				switch  rnd(100)/100
		{
		match_between [0 , 0.05] {appreciation_densite_par_plageur<- "fort_moyen_pas_faible" ;}
		match_between [0.06,1] {appreciation_densite_par_plageur<-"faible_moyen_pas_fort" ;} 		
		  }
		}
		
		appreciation_densite_par_plageur<-"faible_moyen_pas_fort" ;//  on impose 100% des gens qui n'aiment pas les denisté forte
		
		if sociabilite= "fort"  { sensibilite_sociabilite <- "pref_centre_gravite";}
		if sociabilite= "neutre"  { sensibilite_sociabilite <- "pas_pref_centre_gravite";}
		
		//// valable pour pour tous les types de population////
		if type_plage = "support 01 plage urbaine" {preference_zone_baignade<- "neutre";}
		appreciation_densite_par_plageur_initiale <- appreciation_densite_par_plageur;
	
	do calcul_rayon_cercle_qd_installe ;}
	
	//// Rayon de la cellule installée selon nb de personne////
	action calcul_rayon_cercle_qd_installe {
		float x<-0.0;
		if population = "Population type Concurrence" {	
			switch taille {
				match 1 {x <- 1.3;}
				match 2 {x <- 1.53;}
				match 3 {x <- 1.75;}
				match 4 {x <- 1.95;}
				match 5 {x <- 2.2;}
				match 6 {x <- 2.38;}
				match 7 {x <- 2.51;}
				match 8 {x <- 2.72;}
				match 9 {x <- 2.78;}
				match 10 {x <- 2.85;}		
			}
		} 
		if population="Population type Gros-Jonc"{
			switch taille {
				match 1 {x <- 1.53;}
				match 2 {x <- 1.81;}
				match 3 {x <- 2.07;}
				match 4 {x <- 2.3;}
				match 5 {x <- 2.5;}
				match 6 {x <- 2.8;}
				match 7 {x <- 2.89;}
				match 8 {x <- 3.06;}
				match 9 {x <- 3.24;}
				match 10 {x <- 3.35;}				
			}
		}
		if population="Population test 1" {
			switch taille {
				match 1 {x <- 1.3;}
				match 2 {x <- 1.53;}
				match 3 {x <- 1.75;}
				match 4 {x <- 1.95;}
				match 5 {x <- 2.2;}
				match 6 {x <- 2.38;}
				match 7 {x <- 2.51;}
				match 8 {x <- 2.72;}
				match 9 {x <- 2.69;}
				match 10 {x <- 2.85;}				
			}
		}
		if population="Population test 2" {
			switch taille {
				match 1 {x <- 1.3;}
				match 2 {x <- 1.53;}
				match 3 {x <- 1.75;}
				match 4 {x <- 1.95;}
				match 5 {x <- 2.2;}
				match 6 {x <- 2.38;}
				match 7 {x <- 2.51;}
				match 8 {x <- 2.72;}
				match 9 {x <- 2.69;}
				match 10 {x <- 2.85;}				
			}
		}
		rayon_cercle_quand_installe <- x;
	}
	
	reflex a_faire_en_debut_de_cycle {
		zone_prospectee<-nil;
		location_precedent<-nil;
		location_avant_installation<-nil;
		possible_loc<-nil;
		}    
    
	bool est_a_l_entree (cellule aCell) {
		return nb_sauts_effectifs = 0;
	}

	int direction_de_la_mer
	{ 
		return ((self direction_to segment_bas_plage)); 
	}
	
	//// ENTREE ///
	reflex entrer when:  time!=0 and time>=heure_arrivee and etat=0{ 	
		write "Entré "+name;
		nb_cellules_entree <- nb_cellules_entree+1;
		nb_personnes_entree <- nb_personnes_entree+taille;
		cumul_nb_cellules_entree <- cumul_nb_cellules_entree+1;
		cumul_nb_personnes_entree <- cumul_nb_personnes_entree+taille;
		nb_cellules_entree_ds_quart_heure <- nb_cellules_entree_ds_quart_heure +1;
		mon_entree<- one_of(entree);   
		location <- mon_entree.location;
		chemin_parcouru <- line([location]);
		heading <- direction_de_la_mer();
		write "heading " +heading; 
		etat<-1;
		if zone_pour_distance_inter_cellules_variable = "Secteur a l'entree" {do ajustement_distance_interCells_a_l_entree;}
	}
		
	action ajustement_distance_interCells_a_l_entree {
		geometry espace_percue <-(circle (rayon_secteur_a_l_entree_pour_distance_intercellules_variable°m) inter zone_sable);  
		int nb_p <-sum((cellule where (each.etat = 2) inside(espace_percue)) collect (each.taille));
		float espace_dispo <- nb_p=0?espace_percue.area:espace_percue.area / nb_p ;
		if espace_dispo < seuil_espace_dispo_peu /*"peu"*/ {distance_inter_cellules_variable<- distance_inter_cellules_peu_de_place;}
		if espace_dispo >= seuil_espace_dispo_peu and espace_dispo < seuil_espace_dispo_beaucoup /*moyen */ {distance_inter_cellules_variable<- distance_inter_cellules_moyennement_de_place;}
		if espace_dispo >= seuil_espace_dispo_beaucoup /*"beaucoup"*/ {distance_inter_cellules_variable<- distance_inter_cellules_beaucoup_de_place;}
	}
	
	action ajustement_distance_interCells_en_fonction_densite_maille {
		switch categorie_espace_disponible_par_plageur_dans_ma_maille(self) {
			match "peu" {distance_inter_cellules_variable<- distance_inter_cellules_peu_de_place;}
			match "moyen" {distance_inter_cellules_variable<- distance_inter_cellules_moyennement_de_place;}
			match "beaucoup"{distance_inter_cellules_variable<- distance_inter_cellules_beaucoup_de_place;}
		} 
	}
	
	action ajustement_distance_interCells_en_fonction_densite_environnante {
		switch espace_dispo_environnant {
			match "peu" {distance_inter_cellules_variable<- distance_inter_cellules_peu_de_place;}
			match "moyen" {distance_inter_cellules_variable<- distance_inter_cellules_moyennement_de_place;}
			match "beaucoup"{distance_inter_cellules_variable<- distance_inter_cellules_beaucoup_de_place;}
		} 
	}
	
	
	int nb_beats_depuis_arrivee {
		int tp<- int(floor((time - heure_arrivee)/ step));
		if tp != nb_sauts {write "Verifier Nb sauts différents du nb de beats";}
		return floor((time - heure_arrivee)/ step);
		
	}

	
	////DEPLACEMENT////
	reflex deplacement when: etat=1{
		nb_sauts <- nb_sauts +1;
		point tpLoc<-copy(location);
		write "0"+name;
		if est_a_l_entree(self) and preference_zone_baignade = 'neutre' and appreciation_densite_par_plageur = 'faible_moyen_pas_fort' 
			{do sauter_dans_secteur_le_moins_dense; write "1"+name;}
		else {
			write "2"+name;
			if self intersects zone_proxi_baignade {
					if preference_zone_baignade = "oui" {
						do sauter_restant_dans_zone (zone_proxi_baignade);
						}
					else {// pas de preference pour zone baignade
						if self intersects zone_haut {
							switch preference_position {
								match "haut" {	do sauter_restant_dans_zone (zone_haut);	}
								match "bas" {	do sauter_vers_zone_bas;	}
								match  "neutre" {	do sauter;	}
								}
						}
						else {if self intersects zone_bas {
							switch preference_position {
								match "haut" {	do sauter_vers_zone_haut;	}
								match "bas" {	do sauter_restant_dans_zone (zone_bas);	}
								match  "neutre" {	do sauter;	}
								}	
						}
						else {if self intersects zone_milieu {
							switch preference_position {
								match "haut" {	do sauter_vers_zone_haut;	}
								match "bas" {	do sauter_vers_zone_bas;	}
								match  "neutre" {	do sauter;	}
								}	
						}}}	
					}	
				}
			else {// n'est pas dans zone proxi baignade
			write "3"+name+ preference_position;
					if preference_zone_baignade = "oui" {
						do sauter_vers_zone_proxi_baignade;
						}
					else {// pas de preference pour zone baignade
					write "4"+name;
						if self intersects zone_haut {
							write "5"+name;
							switch preference_position {
								match "haut" {	do sauter_restant_dans_zone (zone_haut);	}
								match "bas" {	do sauter_vers_zone_bas;	}
								match  "neutre" {	do sauter;	}
								}
						}
						else {if self intersects zone_bas {
							write "6"+name;
							switch preference_position {
								match "haut" {	do sauter_vers_zone_haut;	}
								match "bas" {	do sauter_restant_dans_zone (zone_bas);	}
								match  "neutre" {	do sauter;	}
								}	 
						}
						else {if self intersects zone_milieu {
							write "7"+name;
							switch preference_position {
								match "haut" {	do sauter_vers_zone_haut;	}
								match "bas" {	do sauter_vers_zone_bas;	}
								match  "neutre" {	do sauter;	}
								}
						}}}	
					}
						if not(self intersects zone_sable) {write name+" dans l'eau'";}
			}	
		}
		if tpLoc != location {
			//a effectuer un saut////
			nb_sauts_effectifs<-nb_sauts_effectifs+1;
			distance_parcourue <- distance_parcourue + tpLoc distance_to location;
			chemin_parcouru <- world.add_point_nb (chemin_parcouru,location);    
			do calcul_satisfaction_en_fonction_de_la_marche;
		}
	}
	

	action sauter_vers_zone_proxi_baignade
		{	write name+" sauter_vers_zone_proxi_baignade";
			do sauter_vers_segment_cible (segment_zone_baignade);
		}
		
	action sauter_vers_zone_bas
		{	write name+" sauter_vers_zone_bas";
			do sauter_vers_segment_cible (segment_bas_plage);
		}
		
	action sauter_vers_zone_haut
		{	write name+" sauter_vers_zone_haut";
			do sauter_vers_segment_cible (segment_haut_plage);
		}
		
	action sauter_vers_segment_cible (geometry segment_cible)
		{
			bool pas_trouve_place <- true;
			int tpHeading <- copy(heading);
			point tpLocation <- copy(location);
			int cpt <-0;
			loop while: pas_trouve_place  {
				cpt <- cpt +1;
				location<-tpLocation;
				heading<-tpHeading;
				heading <- un_angle_vers_segment (segment_cible);
				int heading_de_depart <- heading;
				location_precedent <- copy(location);
				do move heading:self.heading;
				heading <- heading_de_depart;
				if not(self intersects zone_sable) or not(empty(cellule overlapping self)) {
					write "boucle pour rester ds la zone sable";
					geometry tp <- line([location, location_precedent]) inter zone_sable;
					loop aCell over: cellule  where (each.name != self.name )
						{tp <- tp - (circle( aCell.rayon_cercle_actuel + rayon_cercle_quand_deplacement)  at_location aCell.location) ;	}
					if tp != nil {
						location <- (any_point_in (tp)) ;
						heading <- heading_de_depart;
						pas_trouve_place<-false;}
					else {if cpt = 100 {write "ICI ";break;}} // Pas de place trouvé au bout de 100 tentatives de trajectoire
					}
				else {pas_trouve_place<-false;}
				}
				
			if pas_trouve_place {
				location<-tpLocation;
				heading <- tpHeading;
				write name + "N'A PAS REUSSI A SAUTER après 100 tentatives";
				}
			else {
				if not(self intersects zone_sable)  {write name +" A SAUTER HORS SABLE";}
				if not(empty(cellule overlapping self)) {write name +" A SAUTER SUR UN AGENT";}
				}			
		}
	
	
	action sauter_dans_secteur_le_moins_dense
		{
			secteur secteur_cible <- first (shuffle(secteur where (each.num_entree = mon_entree.num_entree)) sort_by (each.densite));
			heading <- self direction_to (any_location_in(secteur_cible));
			location_precedent <- copy(location);
			list<unknown>  res <- sauter_restant_dans_zone_et_selon_angle_min_max (secteur_cible, 0,30);
			if res[0] 
				{possible_loc<- res[1];}
			else{
				res <- sauter_restant_dans_zone_et_selon_angle_min_max (zone_sable, 30,60);
				if res[0] 
					{possible_loc<- res[1];}
				else{	possible_loc<- [];
						write name+ " PROBLEME : pas de place dans secteur cible de départ de moindre densite";
						location <- location_precedent;  
						heading <- direction_de_la_mer();
					}
				}
		}

	action sauter
		{	write name+ " sauter";
			location_precedent <- copy(location);
			list<unknown>  res <- sauter_restant_dans_zone_et_selon_angle_min_max (zone_sable, 0,20);
			if res[0] 
				{possible_loc<- res[1];}
			else{
				res <- sauter_restant_dans_zone_et_selon_angle_min_max (zone_sable, 21,90);
				if res[0] 
					{possible_loc<- res[1];}
				else{	possible_loc<- [];
						heading<-heading + 180;
					}
				}
		}
		
	action sauter_restant_dans_zone (geometry zone_actuelle)
		{	write name+" sauter_restant_dans_zone : " + zone_actuelle;
			location_precedent <- copy(location);
			list<unknown>  res <- sauter_restant_dans_zone_et_selon_angle_min_max (zone_actuelle, 0,20); //// NB_Saum
			if res[0] 
				{possible_loc<- res[1];}
			else{
				res <- sauter_restant_dans_zone_et_selon_angle_min_max (zone_actuelle, 21,45); //// NB_Saum
				if res[0] 
					{possible_loc<- res[1];}
				else{	possible_loc<- [];
						heading<-heading + 180;
					}
				}
		}

	list<unknown>  sauter_restant_dans_zone_et_selon_angle_min_max (geometry zone_pref, int angle_min, int angle_max)
		{	
			point tpLoc <- copy(location);
			int tpHeading <- copy(heading);
			list<point> tpList_loc <-[];
			list<int> list_headings <-[];
			loop i from:angle_min to:angle_max { add heading + i to: list_headings; add (heading -i) to:list_headings;}
			
			heading <-tpHeading;
			loop i over: list_headings  {
				heading <- i;
				do move heading:heading ;
				add location to: tpList_loc;
				location <-tpLoc;
				heading <-tpHeading;	
				}
				
			list_headings<- shuffle(list_headings);	
			loop i over: list_headings  {
				location <- tpLoc;
				heading <- i;
				do move heading:heading ;
				if zone_pref covers self and empty(cellule where (each != self) overlapping(self)) {break;}
				else{location <-tpLoc;
					heading <-tpHeading;}	
				}
			return [location != tpLoc,tpList_loc];	
		}
		
	action calcul_satisfaction_en_fonction_de_la_marche {
		switch possibilite_marche  {
			match "peu" 
				{
				if !a_deja_passe_seuil_des_40m {
					if self distance_to mon_entree.location > 40°m {
						a_deja_passe_seuil_des_40m<- true; satisfaction <- satisfaction -2;
						write name + " marche trop : prefMarche peu / seuil 40m ";  }
						}
				else {
					if !a_deja_passe_seuil_des_100m 
						{
							if self distance_to mon_entree.location > 100°m {
								a_deja_passe_seuil_des_100m<- true; satisfaction <- satisfaction -2;
								write name + " marche trop : prefMarche peu / seuil 100m "  ;}
							}
						} 
			}
			match "moyen"
				{
				if !a_deja_passe_seuil_des_100m {
					if self distance_to mon_entree.location > 100°m {
						a_deja_passe_seuil_des_100m<- true; satisfaction <- satisfaction -2;
						write name + " marche trop : prefMarche moyen / seuil 100m ";  
					}
				}
			}
		}
	}
		
	int un_angle_vers_segment (geometry unSegment)     
		{
			list<point> pointsOrdonnes <- unSegment.points sort_by(each distance_to self);
			write pointsOrdonnes;
			int indexMaximumDeLaListDesPoints <- min([7,length(pointsOrdonnes)-1]);
			point targetP <- pointsOrdonnes[rnd(0,indexMaximumDeLaListDesPoints)];
			return (self direction_to targetP) + ((flip(0.5)?1:-1) * rnd(30));
		}	

	geometry  zone_de_preference (cellule aCell) {
		if type_plage = "support 02 plage sauvage" and aCell.preference_zone_baignade =  "oui" 			
			{return zone_proxi_baignade;}
		else {
			switch aCell.preference_position
			 {
				match  "haut"
					{return zone_haut;} 
				match "bas"
					{return zone_bas;} 
				match "neutre"
					{return zone_sable;}
				default {return nil;}
			}
		}
			  
	}

	geometry  zone_de_preference_moins_largeur_cell_installe (cellule aCell) {
		return ( (zone_sable - (rayon_cercle_quand_installe-distance_confort)) inter zone_de_preference(aCell) );
		
	}

	bool estDansZoneDePreference (cellule aCell) {
		return (aCell intersects zone_de_preference(aCell));	  
		}
	
	geometry zone_d_attente_spatiale (cellule aCell) {
		geometry tp <-  zone_de_preference_moins_largeur_cell_installe(aCell);
		if type_plage = "support 02 plage sauvage" 						
			{	if aCell.gene_coquillage="oui" {tp <- tp - zone_coquillage;}
				if aCell.gene_algue="oui"  {tp <- tp - zone_algue;}
		    	if aCell.gene_galet="oui" {tp <- tp - zone_galet;}
		    	}  
		return tp;
	}

	geometry zone_d_attente_spatiale_sans_contrainte_zone_pref (cellule aCell) {
		
		geometry tp  <- (zone_sable - (rayon_cercle_quand_installe-distance_confort)  );
		if type_plage = "support 02 plage sauvage" 						
			{	if aCell.gene_coquillage="oui" {tp <- tp - zone_coquillage;}
				if aCell.gene_algue="oui"  {tp <- tp - zone_algue;}
		    	if aCell.gene_galet="oui" {tp <- tp - zone_galet;}
		    	}  
		return tp;
	}
	
	string categorie_espace_disponible_par_plageur_dans_ma_maille (cellule aCell) {
		maille_20_20 maMaille <- first(maille_20_20 overlapping (aCell));
		if maMaille = nil {write "PROBLEME MAILLE"+aCell.name + first(maille_20_20 overlapping (aCell.location));
							write "location overlaps ?:"+aCell.location overlaps zone_sable;
							write "cell overlaps ?:"+aCell overlaps zone_sable;
							if aCell.location.y  > 60 and aCell.location.y < 61 {
									point pos <- copy(aCell.location ) translated_by {0,-1,0};
								 maMaille <- first(maille_20_20 overlapping (pos));			} 
							if aCell.location.y  > 19.5 and aCell.location.y < 20.1 {
									point pos <- copy(aCell.location ) translated_by {0,1,0};
								 maMaille <- first(maille_20_20 overlapping (pos));	} 
		}
		return maMaille.categorie_espace_disponible_par_plageur ;
	}		

	action calc_espace_dispo_environnant {
		geometry cercleD <- circle(rayon_perception_densite_environnante,self.location);
		int nb_p<-0;
		ask (cellule where (each.etat =2) inside(cercleD)) {
			nb_p <- nb_p + taille;	}
		float m2_par_plageur <- cercleD.area / max([1,nb_p]);
		if m2_par_plageur < seuil_espace_dispo_peu {espace_dispo_environnant <- "peu";}
		else{	if m2_par_plageur > seuil_espace_dispo_beaucoup {espace_dispo_environnant <- "beaucoup";}
				else {espace_dispo_environnant <- "moyen";}
		}
	} 


	////PROSPECTER	/////	
	reflex prospecter when: etat =1 and estDansZoneDePreference(self) {
		write name+" prospecter";
		switch zone_pour_distance_inter_cellules_variable {
			match "Maille" {do ajustement_distance_interCells_en_fonction_densite_maille;}
			match "inactif" {distance_inter_cellules_variable<-0;}
			match "Rayon environnant" {
				do calc_espace_dispo_environnant;
				do ajustement_distance_interCells_en_fonction_densite_environnante;}
			}
		if activer_distance_inter_cellules_pour_marcheurs {
			if (possibilite_marche = "beaucoup" and appreciation_densite_par_plageur = "faible_moyen_pas_fort")
				{write "Distance inter cellule pour marcheur affectée";
				espace_dispo_environnant <-"marcheur";
				distance_inter_cellules_variable <- distance_inter_cellules_pour_marcheurs;
				}}
	
		bool espace_disponible_par_plageur_acceptable <- true; 
		if appreciation_densite_par_plageur = "faible_moyen_pas_fort" 	{		//		appreciation_densite :    "fort_moyen_pas_faible" ou 	"faible_moyen_pas_fort"
			if categorie_espace_disponible_par_plageur_dans_ma_maille(self) = "peu"  {			
				installation_impossible_car_trop_dense <- true; // a cherche a s'installer dans une zone avec trop peu d'espace disponible par plageur
				espace_disponible_par_plageur_acceptable <- false;
				}
		}
		if !espace_disponible_par_plageur_acceptable { 
			write name +"TROP DENSE ICI";
			do adaptation;}
		else {
			
			zone_prospectee <- circle(rayon_prospection) inter zone_d_attente_spatiale_sans_contrainte_zone_pref(self); 
			if zone_prospectee = nil {write "VERIFICATION 1";}
			
			loop aCell over: cellule at_distance (rayon_prospection +self.rayon_cercle_quand_installe + distance_inter_cellules_variable + 3.4) where (each.name != self.name)  
					{ zone_prospectee <- zone_prospectee - (circle( aCell.rayon_cercle_actuel + self.rayon_cercle_quand_installe + distance_inter_cellules_variable)  at_location aCell.location) ; }
			if zone_prospectee = nil { 
				write name +" PAS DE PLACE";
				do adaptation;}
			else {
				// ok installation///
				location_avant_installation<- copy (location);
				switch methode_installation {
					match "Au hasard" {do installer_au_hasard(self, zone_prospectee);}
					match "Au plus loin des autres" {do installer_au_plus_loin_des_autres(self, zone_prospectee);}
					match "Au plus près des autres" {do installer_au_plus_pres_des_autres(self, zone_prospectee);}
					}
				etat<-2;
				write name+" installé";
				chemin_parcouru <- world.remove_last_point(chemin_parcouru); 
				chemin_parcouru <- world.add_point_nb(chemin_parcouru,location);
				do calcul_satisfaction_espace_disponible_par_plageur_a_l_installation;
				}
		}
	} 
	////Adaptation///
	action adaptation {
		write name + " adaptation Nb_sauts " + nb_sauts; 
		do update_perception_elements_gene;
		if nb_sauts >= 6 and preference_zone_baignade = "oui" {
				if self intersects zone_proxi_baignade {preference_zone_baignade <- "neutre"; satisfaction <- satisfaction -6;}}
		if nb_sauts >= 5 and preference_position = "haut"{
				if self intersects zone_haut {preference_position <- "neutre"; satisfaction<- satisfaction -2;}}
		if nb_sauts >= 5 and preference_position = "bas"{
				if self intersects zone_bas {preference_position <- "neutre"; satisfaction<- satisfaction -2;}}

		if nb_sauts = 5 and gene_coquillage = "oui" {
				if a_percu_coquillage {a_percu_coquillage <- false; satisfaction <- satisfaction -2;}}
		if nb_sauts >= 10 and gene_coquillage = "oui" {
				if a_percu_coquillage {gene_coquillage <- "non"; satisfaction <- satisfaction -2;}}

		if nb_sauts = 5 and gene_galet = "oui" {
				if a_percu_galet {a_percu_galet <- false; satisfaction <- satisfaction -2;}}
		if nb_sauts >= 10 and gene_galet = "oui" {
				if a_percu_galet {gene_galet <- "non"; satisfaction <- satisfaction -2;}}
		
		if nb_sauts != 0 and (nb_sauts mod 5 = 0) and gene_algue = "oui" { /// nb_sauts mod 5 = 0    signifie "à chaque fois que la valeur de nb_sauts est un multiple de 5"
				if a_percu_algue {a_percu_algue<- false; satisfaction <- satisfaction -2;}}
				
		if nb_sauts >=15  and appreciation_densite_par_plageur = "faible_moyen_pas_fort" {   
				if installation_impossible_car_trop_dense /* a_cherche_a_s_instaler_dans_une_zone_avec_trop_peu_d_espace_disponible_par_plageur*/{appreciation_densite_par_plageur <- "fort_moyen_pas_faible"; satisfaction <- satisfaction -4;}}
	}
	
	action installer_au_plus_loin_des_autres (cellule aCell, geometry zone_cible) {
		// Prend 100 localisations d’installation possible au hazard et les trie en fonction de la distance par rapport aux autres. La localisation retenue est celle qui est la plus loin des autres parmi ces 100.
		list<cellule> lesAutres <- cellule at_distance (2*rayon_prospection) where (each.etat =2);
		if empty(lesAutres)  {aCell.location <- any_point_in(zone_cible);}
		else {
			list<point> aList;
			loop times: 100 {
				add any_location_in(zone_cible) to: aList;
				}
			aList <- aList sort_by (each distance_to (lesAutres closest_to each)); 
			aCell.location <-last(aList);
		}
	}
		
	action installer_au_plus_pres_des_autres (cellule aCell, geometry zone_cible) {
		// Prend 100 localisations d’installation possible au hazard et les trie en fonction de la distance par rapport aux autres. La localisation retenue est celle qui est la plus loin des autres parmi ces 100.
		list<cellule> lesAutres <- cellule at_distance (2*rayon_prospection) where (each.etat =2);
		if empty(lesAutres)  {aCell.location <- any_point_in(zone_cible);}
		else {
			list<point> aList;
			loop times: 100 {
				add any_location_in(zone_cible) to: aList;
				}
			aList <- aList sort_by (each distance_to (lesAutres closest_to each)); 
			aCell.location <-first(aList);
		}
	}
			
	action installer_au_hasard (cellule aCell, geometry zone_cible)  {
		aCell.location <- (any_point_in (zone_cible));
		}	
	
	action calcul_satisfaction_espace_disponible_par_plageur_a_l_installation {
		if appreciation_densite_par_plageur_initiale = "faible_moyen_pas_fort" {
				string cat <- categorie_espace_disponible_par_plageur_dans_ma_maille(self);
				if cat = "peu" {satisfaction <- satisfaction -4;}
				espace_dispo_avant <- cat; 
		}
	}

	////INSTALLER///
	reflex evaluer_pendant_installation when:etat=2{
		temps_ecoule<-temps_ecoule+step;
		if temps_ecoule >= duree_installation_prevue { do atomiser; }
		else{do calcul_satisfaction_en_cours_installation;}
	}
	
	action calcul_satisfaction_en_cours_installation{
		if appreciation_densite_par_plageur_initiale = "faible_moyen_pas_fort" {
			string cat <- categorie_espace_disponible_par_plageur_dans_ma_maille(self); 
			if cat != espace_dispo_avant { 
				if cat = "peu" and espace_dispo_avant != "peu"
					 {satisfaction <- satisfaction - 4;}
				if espace_dispo_avant = "peu" and cat != "peu"
					 {satisfaction <- satisfaction + 4;}
			}
			espace_dispo_avant <- cat;
		}
	}
	
	///PARTIR///
	action atomiser  {
		cumul_nb_cellules_sortie <- cumul_nb_cellules_sortie+1;
		cumul_nb_personnes_sortie <- cumul_nb_personnes_sortie+taille;
		do die ;
	}
	
		
	action update_perception_elements_gene{
			if !a_percu_coquillage {if  circle(rayon_prospection) intersects zone_coquillage {a_percu_coquillage <- true;}}
			if !a_percu_galet {if  circle(rayon_prospection) intersects zone_galet {a_percu_galet <- true;}}
			if !a_percu_algue {if  circle(rayon_prospection) intersects zone_algue {a_percu_algue <- true;}}
		}
	
	/// Couleurs des cellules selon la satisafaction, le taille, le statut....///	
	rgb couleur_cellule {
		switch etat {
			match 2 {
				switch type_couleur_cellule {
					match "enfant" {return couleur_par_enfant[enfant];}
					match "statut"{return couleur_par_statut[statut];}
					match "env"{return couleur_par_env[env];}
					match "satisfaction" { switch satisfaction {
									match_between [0,4] {return couleur_par_satisfaction["[0 à 4]"];}
									match_between [5,9] {return couleur_par_satisfaction["[5 à 9]"];}
                    				match_between [10,13] {return couleur_par_satisfaction["[10 à 13]"];}
                    				match_between [14,17] {return couleur_par_satisfaction["[14 à 17]"];}
                    				match_between [18,20] {return couleur_par_satisfaction["[18 à 20]"];}}
									}
					match "taille" { switch taille {
									match_between [1,2] {return couleur_par_taille[string(taille)];}
									match_between [3,5] {return couleur_par_taille["[3,5]"];}
									match_between [6,8] {return couleur_par_taille["[6,8]"];}
									default {return couleur_par_taille["[9,10]"];}}
									}
					match "pref zone"{return couleur_par_pref_zone[pref_zone];}
					match  "espace dispo environnant" {return couleur_par_espace_dispo_environnant[espace_dispo_environnant];}
					default {return color;}
					}
			}  
			default {return color;}
		}
	} 
	
	aspect base
	{
		switch aspect_cellule
		{
			match "zone_confort"
			{
				draw shape color: couleur_cellule();
			}
			match "serviette"
			{
				if etat = 2
				{
					draw shape - distance_confort color: couleur_cellule() border: false;
				} else
				{
					draw shape color: couleur_cellule();
				}
			}
			match "serviette & zone_confort"
			{
				if etat = 2
				{
					draw shape - distance_confort color: couleur_cellule() border: false;
					draw shape - (shape - 0.01) color: #black;
				} else
				{
					draw shape color: couleur_cellule();
				}
			}
		}
	}
        
    aspect aspect_zone_prospectee {
    	 if afficher_zone_prospectee {
		 	draw zone_prospectee color: rgb(91, 154, 185,150);  
		}	}
		 
    aspect aspect_ligne_deplacement {
    	 if afficher_zone_prospectee {
		 	draw line ([location_precedent, etat=2? location_avant_installation:location],0.1);
		 	draw line ([location_precedent, etat=2? location_avant_installation:location]); /// Astuce pour que la variable de width/size du dessin revienne à la valeur par défaut
		 	if etat=2{
		 			int id<- int(self);
		 			draw string(id) color:#black at:location_avant_installation;}
		}	}
		
	aspect aspect_chemin_parcouru {
    	 switch affichage_chemin_parcouru {
		 	match "Temporaire" {if temps_ecoule < 61 {draw chemin_parcouru color:#black;}}
		 	match "Permanent" {draw chemin_parcouru color:#black;}
		}
	}	
	
    aspect aspect_id_agent {
    	 if afficher_zone_prospectee {
		 	int id<- int(self);
		 	draw string(id) color:#black ;
	 	}	}
        
    aspect aspect_orientation_saut {
    	if afficher_zone_prospectee {
			loop pt over: possible_loc {
				draw triangle(0.5) at: pt color: #green;
				}
    	}	}
    
    reflex change_shape {
        if(etat=2) {
        	rayon_cercle_actuel <- rayon_cercle_quand_installe; //la taille du cercle augmente en fonction de la taille de la cellule…
        	shape <- circle (rayon_cercle_actuel);
        	color <- couleur_cellule_installe;  
			}
		}
	
	//// Export des résultats en csv et en shp////		
	reflex export_resultat when: export !=false  and (time mod 3600 =0) and etat !=0 {
		save ("heure: "+ int(floor(time/3600))+"h "+ int(floor((time mod 3600)/60))+"mn "+((time mod 3600)mod 60) +"s" 
			+ "; statut : "+statut
			+"; taille de la cellule:" + taille
			+ "; enfant : " + enfant
			+ "; environnement :" +env
			+" ; sociabilite : "+sociabilite
			+"; heure arrivee :"+heure_arrivee
			+ "; duree d'installation: " + duree_installation_prevue
			+ " ; preference position :"+preference_position
			+ "; preference zone baignade :"+preference_zone_baignade
			+  "; appreciation_densite_par_plageur: " + appreciation_densite_par_plageur
			+" ; possibilite de marcher :"+possibilite_marche
			+ "; gene algues : " +gene_algue
			+ "; gene coquillages : " +gene_coquillage
			+ "; gene galets : " +gene_galet
			+" ; sensibilite_sociabilite : "+sensibilite_sociabilite
			+ "; etat : "+etat
			+" ; nb de sauts :"+nb_sauts
			+ " ; satisfaction :"+satisfaction
			+" ; rayon cercle actuel:"+rayon_cercle_actuel
			+ "; temps ecoule :"+temps_ecoule
			+ "; localisation :"+ location)
			
	   		to: export_csv + "_" +string(time/3600)+".csv" type: "csv" rewrite: false;
	   	}
	
	   reflex export_resultat_shp when: export !=false  and (time mod 3600 =0) and etat !=0  {
		    save list(cellule) to: export_shp   + "_" +string(time/3600)+".shp" type:"shp" with:[
			appreciation_densite_par_plageur::"app_densi", 
			heure_arrivee::"heure_arrivee",
			duree_installation_prevue::"duree_prev", 
			enfant::"enfant",env::"env", 
			etat::"etat", 
			gene_algue::"gene_algue", 
			gene_coquillage::"gene_coquill", 
			gene_galet::"gene_galet", 
			nb_sauts::"nb_saut",
			possibilite_marche::"possi_marche",
			preference_position::"pref_position", 
			preference_zone_baignade::"pref_zone_baignade", 
			rayon_cercle_actuel::"rayon_cercle actuel",
			satisfaction ::"satisfaction",
			sociabilite::"sociabilite",
			statut:: "statut",
			temps_ecoule ::"temps_ecoule",
			taille::"taille",
			location::"location"
		] crs: "EPSG:4326";
		}
		
		reflex calcul_pourcentage_satisfaction {
				list<int> ds <- (cellule where (each.etat = 2 ) collect (each.satisfaction));
				if !empty(ds) {
					percSatisf1 <- round(100* (length(ds where (each > 17.99))/length(ds)));
					percSatisf2 <- round(100* (length(ds where (each between (13.99,18)))/length(ds)));
					percSatisf3 <- round(100* (length(ds where (each between (9.99,14)))/length(ds)));
					percSatisf4 <- round(100* (length(ds where (each between (3.99,10)))/length(ds)));
					percSatisf5 <- round(100* (length(ds where (each < 4))/length(ds)));
					}
				else {percSatisf1<- 0; percSatisf2 <- 0; percSatisf3 <- 0; percSatisf4 <- 0;percSatisf5 <- 0;}		
		}
}


experiment ModelPlage type: gui until: empty (cellule) {
	/// Paramètres de simulation ////
	parameter "Choisir un nombre de cellules: " var: nb_cellules_init /*min: 1 max: 3000*/ category: "Générer une population" ;
	parameter "Choisir un type de population: " var: population <- "Population type Gros-Jonc" among: ["Population type Concurrence","Population type Gros-Jonc", "Population test 1", "Population test 2"] category: "Générer une population" ;
	parameter "Choisir un type de plage: " var: type_plage <- "support 02 plage sauvage" among: ["support 01 plage urbaine","support 02 plage sauvage"] category: "Configuration spatiale et temporelle de la plage" ;
	parameter "Choisir un type d'entretien: " var: configuration_plage<- "plage nettoyee" among: ["plage nettoyee","plage partiellement nettoyee","plage non nettoyee"] category: "Configuration spatiale et temporelle de la plage" ;
	parameter "Choisir un rythme: " var: rythme <-"rythme02"  among: ["rythme01","rythme02","rythme test 1","rythme test 2"] category: "Configuration spatiale et temporelle de la plage" ;
	
	/// Paramètres d'export ////
	parameter "Exporter les résulats ?  " var: export <-false category: "Export" ;
	
	//// Paramètres du fonctionnement du modèle///
	parameter "Distance parcourue avant prospection (en mètres)" var: dist_saut /*min: 5°m max: 20°m*/ step: 1 category: "Paramètres de déplacement / installation" ;
	parameter "Rayon de la zone de prospection (en mètres)" var: rayon_prospection /*min: 5°m max: 50°m*/ step: 1 category: "Paramètres de déplacement / installation" ;
	parameter "Types de choix d'installation dans zone prospectée" var: methode_installation /*<- "Au hasard"*/ among: ["Au hasard", "Au plus loin des autres","Au plus pres des autres"] category: "Paramètres de déplacement / installation" ;	
	parameter "Zone considérée pour calcul de l'espace dispo" var: zone_pour_distance_inter_cellules_variable <- "Rayon environnant" among:["inactif", "Maille", "Secteur a l'entree","Rayon environnant"] category: "Paramètres - adaptation à la densité" ;
	parameter "Rayon du secteur à l'entrée" var: rayon_secteur_a_l_entree_pour_distance_intercellules_variable /*min: 20°m max: 200°m*/ step: 1 category: "Paramètres - adaptation à la densité" ;
	parameter "Rayon de la densité environnante" var: rayon_perception_densite_environnante  step: 1 category: "Paramètres - adaptation à la densité" ;
	parameter "Densité forte si inférieure à (en m2/plageur)" var: seuil_espace_dispo_peu /*min: 1°m2 max: 200°m2*/ step: 1 category: "Paramètres - adaptation à la densité" ;
	parameter "Densité faible si supérieure à (en m2/plageur)" var: seuil_espace_dispo_beaucoup /*min: 1°m2 max: 200°m2*/ step: 1 category: "Paramètres - adaptation à la densité" ;
	parameter "Distance inter-cellules mini si densité forte (en mètres)" var: distance_inter_cellules_peu_de_place /*min: 0°m max: 20°m*/ step: 1 category: "Paramètres - adaptation à la densité" ;
	parameter "Distance inter-cellules mini si densité moy (en mètres)" var: distance_inter_cellules_moyennement_de_place /*min: 0°m max: 20°m*/ step: 1 category: "Paramètres - adaptation à la densité" ;
	parameter "Distance inter-cellules mini si densité faible (en mètres)" var: distance_inter_cellules_beaucoup_de_place /*min: 0°m max: 20°m*/ step: 1 category: "Paramètres - adaptation à la densité" ;
	parameter "Activer Distance inter-cellules pour les marcheurs" var: activer_distance_inter_cellules_pour_marcheurs <- true category: "Paramètres - Distance inter-cellules pour les marcheurs";
	parameter "Distance inter-cellules min pour les marcheurs" var: distance_inter_cellules_pour_marcheurs step: 1 category: "Paramètres - Distance inter-cellules pour les marcheurs";
	
	/// Paramètre d'affichage ///
	parameter "Affiche de la zone prospectée" var: afficher_zone_prospectee<- false category: "Affichage chemins et zone prospectée" ;
	parameter "Affichage du chemin parcouru" var: affichage_chemin_parcouru <- "Non" among: ["Non", "Temporaire" ,"Permanent"] category: "Affichage chemins et zone prospectée" ;
	parameter "Affiche des séparateurs zones plage" var: afficher_segments<- false category: "Affichage chemins et zone prospectée" ;
	parameter "Contour des cellules" var: aspect_cellule <- "serviette"  among: ["serviette"] category: "Affichage Cellules" ;
	parameter "Couleur des cellules" var: type_couleur_cellule <- "aucun"  among: ["aucun","enfant" ,"statut", "taille", "env", "pref zone", "espace dispo environnant", "satisfaction"] category: "Affichage Cellules" ;
	
		
	output {
				
		display "Carte de la plage" {
			
			///Bandeau d'informations au dessus de la carte ///
            overlay "Legend" position: { 5, 0 } size: {1300#px , 80#px} background: #black transparency: 0.8 border: #black rounded: true
            {
            	draw "Heure"at: {30#px,30#px} font: fontTexteHautDeCarte1 color: #white ;
            	draw ""+H +"h "+ MN +"mn "+ S +"s" at: {10#px,55#px} font: fontTexteHautDeCarte1 color: #white ;
            	
            	draw "Nombre de cellules sur la plage : " + length(cellule where (each.etat = 2 or each.etat =1) ) at: {160#px,30#px} font: fontTexteHautDeCarte2 color: #white ;
				draw "Nombre de personnes sur la plage : " + sum (cellule where (each.etat = 2 or each.etat =1) accumulate (each.taille)) at: {160#px,60#px} font:fontTexteHautDeCarte2 color: #white ;
				draw "Satisfaction: "+mean(cellule where (each.etat = 2 ) collect  (each.satisfaction)) with_precision 1 at: {540#px,50#px} font:fontTexteHautDeCarte2 color: #white ;
				
				
            	///Légende de la couleur des cellules ///
            	if type_couleur_cellule !="aucun" {
            		map code_couleur;
            		switch type_couleur_cellule {
            			match "enfant" {code_couleur <- couleur_par_enfant;}
            			match "statut" {code_couleur <- couleur_par_statut;}
            			match "taille" {code_couleur <- couleur_par_taille;}
            			match "env" {code_couleur <- couleur_par_env;}
            			match "pref zone" {code_couleur <- couleur_par_pref_zone;}
            			match "espace dispo environnant" {code_couleur <- couleur_par_espace_dispo_environnant;}
            			match "satisfaction" {code_couleur <- couleur_par_satisfaction;}
            		}
	                float y <- 15#px;
	                int i<-1;
	                float xc<-0#px;
	                loop type over: code_couleur.keys
	                {
	                	if i = 4 {y <-15#px; xc<-200#px;}
	                    draw circle(10#px) at: { 780#px + xc, y } color: code_couleur[string(type)] border: #white;
	                    draw string(type) at: { 800#px + xc, y + 4#px } color: # white font: fontTexteHautDeCarte3;
	                    y <- y + 25#px;
	                    i<-i+1;
	                }
                }
			}
			species fond aspect:base ;
			species zone aspect:base;
			species segment aspect:base;
			species fleche aspect: base;
			species element aspect:base;
			species entree aspect: base;
			species cellule aspect: base ;
			species cellule aspect: aspect_zone_prospectee ;
			species cellule aspect: aspect_orientation_saut ;
			species cellule aspect: aspect_ligne_deplacement ;
			species cellule aspect: aspect_chemin_parcouru ;
			species cellule aspect: aspect_id_agent ;	
		}
		
		display "Satisfaction moyenne"{
			chart "moyenne de la satisfaction des cellules"type: series x_serie_labels: texte_heure_mn x_label: "Heure" x_tick_unit: 30 y_range: 20 y_tick_unit: 1 y_label: "Point de satisfaction" {
				data "satisfaction moyenne" value:mean(cellule where (each.etat = 2 ) accumulate (each.satisfaction)) color:#red marker:false;
				}
		}
		
		display "Satisfaction"{
			chart "Distribution des cellules par tranche de satisfaction"type: series  x_serie_labels: texte_heure_mn x_label: "Heure" x_tick_unit: 30 y_range: 100 y_tick_unit: 10 y_label: "Pourcentage" {
					data "satisfaction < 5" value: percSatisf5 color:rgb(255,0,0)  marker:false style:"area";
					data "satisfaction [5;9]" value: percSatisf4 + percSatisf5 color:rgb(231,120,43) marker:false style:"area";
					data "satisfaction [10;13]" value: percSatisf3 + percSatisf4 + percSatisf5 color:rgb(247,168,67) marker:false style:"area";
					data "satisfaction [14;17]" value: percSatisf2 + percSatisf3 + percSatisf4 + percSatisf5 color:rgb(140,186,98) marker:false style:"area";
					data "satisfaction [18;20]" value: percSatisf1 + percSatisf2 + percSatisf3 + percSatisf4 + percSatisf5 color:rgb(5,136,55) marker:false style:"area";
				}
		}
		
		display "Densité des mailles" {
			chart "Densité des mailles" type:series  x_serie_labels: texte_heure_mn x_label: "Heure" x_tick_unit: 30 y_range: 100 y_tick_unit: 10 y_label: "Pourcentage de mailles" {
				data "Peu d'espace disponible : < "+seuil_espace_dispo_peu+"m2 / plageur" value: percMaille_PeuEspace color:#red marker:false style:"area";
				data "Moyennement d'espace disponible : ]"+seuil_espace_dispo_peu+";"+seuil_espace_dispo_beaucoup+"[ m2 / plageur" value: percMaille_PeuEspace + percMaille_MoyenEspace color:#orange marker:false style:"area";
				data "Beaucoup d'espace disponible : > "+seuil_espace_dispo_beaucoup+"m2 / plageur" value: percMaille_PeuEspace + percMaille_MoyenEspace+ percMaille_BeaucoupEspace color:#green marker:false style:"area";
				}
			}
		
		display "Temps de recherche"{
			chart "Temps de recherche d'un emplacement des cellules non installées"type: series  x_serie_labels: texte_heure_mn  x_label: "Heure" x_tick_unit: 30 y_label: "Minutes" y_tick_unit:1
			{
				data "Temps de recherche moyen" value: mean(cellule where (each.etat =1) collect (each.nb_sauts /2)) color:#black style:line marker:false;
				data "Temps de recherche maximum" value: max(cellule where (each.etat =1) collect (each.nb_sauts /2))  color:#red style:line line_visible:false  marker:true marker_shape:marker_down_triangle; 
			}
		}
		
		display "Distance parcourue"{
			chart "Distance parcourue des cellules en recherche d'un lieu d'installation"type: series  x_serie_labels: texte_heure_mn  x_label: "Heure" x_tick_unit: 30 y_label: "Mètres parcourues" y_tick_unit:10
			{
				data "Distance parcourue moyenne" value: mean(cellule where (each.etat =1) collect (each.distance_parcourue)) color:#black style:line marker:false;
				data "Distance parcourue maximum" value: max(cellule where (each.etat =1) collect (each.distance_parcourue)) color:#red style:line line_visible:false  marker:true marker_shape:marker_down_triangle; 
			}
		}

		display "Rythme d'entrée" {
			chart "Rythme d'entree"type: series x_serie_labels: texte_heure_mn_moins15  x_label: "Heure" x_tick_unit: 30 y_label: "Nombre de cellules" 
			{
					data "rythme" value: nb_cellules_entree_ds_quart_heure2=0?nil:nb_cellules_entree_ds_quart_heure2 color:#red marker:false style:step;				
			}
		}
		
		display "Entrées-sorties Cellules" {
			chart "Compteur des entrées sorties des cellules" type: series  x_serie_labels: texte_heure_mn  x_label: "Heure" x_tick_unit: 30 y_label: "Nombre de cellules"
				{
				data "Cellules entrées" value: cumul_nb_cellules_entree color:#blue marker:false;
				data "Cellules sorties" value: cumul_nb_cellules_sortie color:#red marker:false;					
				}
		}
		
		display "Entrées-sorties Personnes" {
			chart "Compteur des entrées sorties des personnes"type: series  x_serie_labels: texte_heure_mn  x_label: "Heure" x_tick_unit: 30 y_label: "Nombre de personnes"
				{
				data "Personnes entrées" value: cumul_nb_personnes_entree color:#blue marker:false;
				data "Personnes sorties" value: cumul_nb_personnes_sortie color:#red marker:false;					
				}
		}
		
		display "Cellules sur la plage" {
			chart "Cellules sur la plage" type: series  x_serie_labels: texte_heure_mn x_label: "Heure" x_tick_unit: 30 y_label: "Nombre de cellules"{
				data "cellule installée" value: cellule count  (each.etat = 2)  color: #red  style:step marker:false;
				}
			}
			
		display "Personnes installées sur la plage" {
			chart "Personnes installées sur la plage" type:series  x_serie_labels: texte_heure_mn x_label: "Heure" x_tick_unit: 30 y_label: "Nombre de personnes"{
				data "personnes installées" value: int(sum (cellule where (each.etat = 2) collect (each.taille))) color: #red marker:false;
				}
			}
	  }
		
	}
	