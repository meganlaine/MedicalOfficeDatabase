/*
	Project 8
    IT 125 Winter 2019
    Database Name: 			doctors_office
    Database Description: 	A sample database for a small doctors office
    Group Members: 			Keith (Boonrhit) Chirayus,
							Megan Laine,
                            Margarita (Rita) Yatina
                            
    Version: 				11 March 2019 (standardizing PK and FK names to format:           
                                    (PorF)K_currentTableName_currentTableColumnName)
*/

/*
	CREATE DATABASE
*/
DROP DATABASE IF EXISTS doctors_office;

CREATE DATABASE doctors_office;

USE doctors_office;

/*
	CREATE TABLES
*/

CREATE TABLE doctor
(
	dr_id			INT             PRIMARY KEY		AUTO_INCREMENT,
    dr_fname		VARCHAR(45) 	NOT NULL,
    dr_lname 		VARCHAR(45)		NOT NULL,
    dr_specialty   	SET('primary care', 'pediatrics', 'allergist', 'gynecologist', 'urgent care')	NOT NULL,
	dr_pager_num	CHAR(10)		NOT NULL
);

CREATE TABLE doctor_photo
(
    dr_id		INT     NOT NULL,
	dr_photo	BLOB	NULL,
	CONSTRAINT     						PRIMARY KEY (dr_id),
    CONSTRAINT fk_doctor_photo_dr_id    FOREIGN KEY (dr_id) REFERENCES doctor (dr_id)
);
    
CREATE TABLE patient
(
    pt_id		INT     		NOT NULL        AUTO_INCREMENT,
    pt_fname    VARCHAR(45)		NOT NULL,
    pt_lname    VARCHAR(45)		NOT NULL,
    pt_birthday DATE			NOT NULL,
    pt_phone    CHAR(10)		NOT NULL,
    pt_address  VARCHAR(30)		NOT NULL,
    pt_city     VARCHAR(15)		NOT NULL,
    pt_state    ENUM('AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA', 
					'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD', 
					'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 
                    'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC', 
                    'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY')
								NOT NULL,
    pt_zip      CHAR(5)			NOT NULL,
    CONSTRAINT PK_patient_pt_id
        PRIMARY KEY (pt_id)
);

CREATE TABLE patient_photo
(
    pt_id               INT     NOT NULL        AUTO_INCREMENT,
    pt_photo            VARCHAR(1400),
    CONSTRAINT PK_patient_photo_pt_id
        PRIMARY KEY (pt_id),
    CONSTRAINT FK_patient_photo_pt_id
        FOREIGN KEY (pt_id)
        REFERENCES patient (pt_id)
);

CREATE TABLE emergency_contact
(
    pt_id               INT     		NOT NULL        AUTO_INCREMENT,
    ec_name             VARCHAR(45)		NOT NULL,
    ec_phone            CHAR(10)		NOT NULL,
    ec_relationship     ENUM('Spouse', 'Parent', 'Partner', 'Guardian')	NOT NULL,
    ec_notes            VARCHAR(150)	NULL,
    CONSTRAINT PK_emergency_contact_pt_id
        PRIMARY KEY (pt_id),
    CONSTRAINT FK_emergency_contact_pt_id
        FOREIGN KEY (pt_id)
        REFERENCES patient (pt_id)
);

CREATE TABLE insurer
(
    insurer_id      INT         PRIMARY KEY     AUTO_INCREMENT,
    insurer_name    VARCHAR(20) NOT NULL,
    insurer_phone   CHAR(10)    NOT NULL
);

CREATE TABLE appointment_type
(
    appt_type_id            INT             PRIMARY KEY     AUTO_INCREMENT,
    appt_type_description   ENUM('annual adult',	'annual child',
								 'focused adult', 	'focused child',
                                 'urgent adult', 	'urgent child')		NOT NULL,
    appt_type_cost          DECIMAL(5,2)    NULL
);

CREATE TABLE diagnosis
(
    dx_code     CHAR(3)     PRIMARY KEY,
    dx_name     VARCHAR(40) NOT NULL
);

CREATE TABLE appointment
(
    appt_id         INT     PRIMARY KEY     AUTO_INCREMENT,
    appt_date       DATE    NOT NULL,
    appt_time       TIME    NOT NULL,
    pt_id           INT     NOT NULL,
    dr_id           INT     NOT NULL,
    appt_type_id    INT     NOT NULL,
    CONSTRAINT 		FK_appointment_pt_id 	FOREIGN KEY (pt_id) 		REFERENCES  patient (pt_id),
    CONSTRAINT      FK_appointment_dr_id  	FOREIGN KEY (dr_id) 		REFERENCES  doctor (dr_id),
    CONSTRAINT      FK_appointment_appt_type_id	FOREIGN KEY (appt_type_id) 	REFERENCES  appointment_type (appt_type_id)
);

CREATE TABLE diagnosis_list
(
	dx_list_id		INT			AUTO_INCREMENT		PRIMARY KEY,
    appt_id    		INT			NOT NULL,
    dx_code    		CHAR(3)     NOT NULL,    
	CONSTRAINT FK_diagnosis_list_appt_id    FOREIGN KEY (appt_id) REFERENCES appointment (appt_id),
	CONSTRAINT FK_diagnosis_list_dx_code    FOREIGN KEY (dx_code) REFERENCES diagnosis (dx_code)
);

CREATE TABLE pt_insurance
(
	pt_insurance_id     VARCHAR(15)     NOT NULL     PRIMARY KEY,
    insurer_id          INT             NOT NULL,
    pt_id               INT             NOT NULL,
    CONSTRAINT FK_pt_insurance_insurer_id	FOREIGN KEY (insurer_id)	REFERENCES insurer (insurer_id),
    CONSTRAINT FK_pt_insurance_pt_id FOREIGN KEY (pt_id) 		REFERENCES patient (pt_id)
);

CREATE TABLE reimbursement_rate
(
    insurer_id          INT             NOT NULL      AUTO_INCREMENT,
    appt_type_id        INT             NOT NULL,
    reimbursement_rate  DECIMAL(4,1)    NOT NULL,
    CONSTRAINT PK_reimbursement_rate_insurer_id_appt_type_id	PRIMARY KEY (insurer_id, appt_type_id),
	CONSTRAINT FK_reimbursement_rate_insurer_id	FOREIGN KEY (insurer_id)	REFERENCES insurer (insurer_id),
    CONSTRAINT FK_reimbursement_rate_appt_type_id FOREIGN KEY (appt_type_id)	REFERENCES appointment_type (appt_type_id)
);

/*
	ADD SAMPLE DATA TO TABLES
*/

# 10 samples
INSERT INTO doctor
	(dr_id,	dr_fname, dr_lname, dr_specialty, dr_pager_num)
VALUES
	(1,'Madie',    'Vanderhoff',	'primary care', 2346576290),
    (2,'Treasa',    'Boyland',      'pediatrics',   2344456734),
    (3,'Oda',       'Petties',      'gynecologist', 2879765839),
    (4,'Sharmaine', 'Wolverton',    'urgent care',  2819313477),
    (5,'Steve',     'Sauer',    	'urgent care',  2345678977),
    (6,'Kasie',     'Roney',    	'gynecologist', 3570275444),
    (7,'Adrianne',  'Jacinto', 		'urgent care',  1096468456),
    (8,'Milan',     'Curlee',   	'pediatrics',   4445677685),
    (9,'Devona',    'Dicarlo',  	'urgent care',  2489056766),
    (10,'Sheryl',   'Stockard', 	'allergist',	4367869899);

# 10 samples
INSERT INTO doctor_photo
	(dr_id, dr_photo)
VALUES
	(1,	LOAD_FILE('Macintosh HD/Users/margaritayatina/Desktop/1.jpg')),
	(2,	LOAD_FILE('Mcintosh HD /Users/margaritayatina/Desktop/2.jpg')),
	(3,	LOAD_FILE('Macintosh HD/Users/margaritayatina/Desktop/3.jpg')),
	(4,	LOAD_FILE('Macintosh HD/Users/margaritayatina/Desktop/4.jpg')),
	(5,	LOAD_FILE('Macintosh HD/Users/margaritayatina/Desktop/5.jpg')),
	(6,	LOAD_FILE('Macintosh HD/Users/margaritayatina/Desktop/6.jpg')),
	(7,	LOAD_FILE('Macintosh HD/Users/margaritayatina/Desktop/7.jpg')),
	(8,	LOAD_FILE('Macintosh HD/Users/margaritayatina/Desktop/8.jpg')),
	(9,	LOAD_FILE('Macintosh HD/Users/margaritayatina/Desktop/9.jpg')),
	(10,LOAD_FILE('Macintosh HD/Users/margaritayatina/Desktop/10.jpg'));

# 32 samples
INSERT INTO patient
    (pt_fname, pt_lname, pt_birthday, pt_phone, pt_address, pt_city, pt_state, pt_zip)
VALUES
	('Jareb',    	'Kubecka',  	'1971-10-10', 	'3147165226', 	'02142 Fordem Trail', 			'Saint Louis',		'MO', 	'63167'	),
	('Delilah',    	'De Malchar', 	'1960-10-28', 	'3197700367', 	'3858 Hudson Trail', 			'Waterloo', 		'IA', 	'50706'	),
	('Laurene',    	'Butterick', 	'1959-10-21', 	'3145999878', 	'8466 Lien Street', 			'Saint Louis', 		'MO', 	'63136'	),
	('Jess',    	'Ainsley', 		'1952-06-10', 	'5134336718', 	'96 Elmside Alley', 			'Cincinnati', 		'OH', 	'45264'	),
	('Sherill',    	'Klosa', 		'1974-02-24', 	'8039740308', 	'0055 Eliot Point', 			'Columbia', 		'SC', 	'29240'	),
	('Pru',    	 	'Tonsley', 		'1982-12-30', 	'6192708812', 	'9228 Dorton Way', 				'Chula Vista', 		'CA', 	'91913'	),
	('Ferdinanda',  'Amies', 		'1972-07-12', 	'5052801215', 	'46460 Washington Junction',	'Albuquerque', 		'NM', 	'87190'	),
	('Rubin',    	'Brocklebank', 	'1970-02-21', 	'8639251827', 	'32 Hauk Park', 				'Lehigh Acres', 	'FL', 	'33972'	),
	('Lucho',    	'Louth', 		'1963-10-24', 	'7121133979', 	'841 Blackbird Pass', 			'Omaha', 			'NE', 	'68134'	),
	('Odele',    	'Sill', 		'1950-07-02', 	'5628178998', 	'389 Artisan Junction', 		'Long Beach', 		'CA', 	'90840'	),
	('Lindsay',    	'Gwilliam', 	'1958-02-06', 	'5854502524', 	'14 Londonderry Hill', 			'Rochester', 		'NY', 	'14683'	),
	('Felic',    	'Barnard', 		'1973-10-08', 	'4081782226', 	'09810 5th Drive', 				'San Jose', 		'CA', 	'95173'	),
	('Antonietta',  'Binnes', 		'1960-12-21', 	'7186211271', 	'34184 Farwell Trail', 			'Staten Island', 	'NY', 	'10305'	),
	('Perle',    	'Loughman', 	'1982-10-10', 	'6169449337', 	'61632 Lukken Center', 			'Grand Rapids', 	'MI', 	'49518'	),
	('Garvey',    	'O''Codihie', 	'1987-12-29', 	'3152786619', 	'190 Huxley Junction', 			'Syracuse', 		'NY', 	'13224'	),
	('Bartel',		'Cohen', 		'1956-09-13', 	'2121586906', 	'796 Morrow Lane', 				'Jamaica', 			'NY', 	'11499'	),
	('Onfroi',    	'Broz', 		'1983-01-03', 	'2131988248', 	'17179 Amoth Road', 			'Los Angeles', 		'CA', 	'90081'	),
	('Milissent',   'Woodgate', 	'1953-07-18', 	'9189137194', 	'439 Stang Avenue', 			'Tulsa', 			'OK', 	'74126'	),
	('Eula',    	'Tarney', 		'1979-05-27', 	'8175489619', 	'02 Hanover Parkway', 			'Fort Worth', 		'TX', 	'76110'	),
	('Derwin',    	'Brouncker', 	'1953-07-23', 	'4069540547', 	'57655 Fremont Pass', 			'Billings', 		'MT', 	'59112'	),
	('Madelin',    	'Linney', 		'1973-02-18', 	'9047472295', 	'8 Pleasure Court', 			'Jacksonville', 	'FL', 	'32215'	),
	('Jerrie',    	'Surgener', 	'1984-03-28', 	'2252600399', 	'3 Pine View Hill', 			'Baton Rouge', 		'LA', 	'70836'	),
	('Marita',    	'Clifft', 		'1959-11-09', 	'2126101030', 	'959 Fordem Center', 			'New York City', 	'NY', 	'10203'	),
	('Lindsey',    	'Bonn', 		'1989-09-15', 	'4345967648', 	'3271 Macpherson Terrace', 		'Charlottesville', 	'VA',	'22908'	),
	('Quint',    	'Ulyet', 		'1958-04-12', 	'3103431764', 	'27057 Heffernan Point', 		'Van Nuys', 		'CA',	'91406'	),
	('Sunny',    	'Coppard', 		'1953-12-22', 	'8108979766', 	'731 Mayer Hill', 				'Flint', 			'MI',	'48505'	),
	('Fidela',    	'Syde', 		'1957-12-18', 	'7164317201', 	'7 Crest Line Point', 			'Buffalo', 			'NY',	'14269'	),
	('Fenelia',    	'Birden', 		'1965-07-24', 	'4088281987', 	'679 Pankratz Hill', 			'San Jose', 		'CA',	'95160'	),
	('Uri',    	 	'Denson', 		'1974-12-23', 	'6123812778', 	'420 Lakeland Alley', 			'Minneapolis', 		'MN',	'55417'	),
	('Cassey',    	'Cready', 		'1977-09-09', 	'4191080085', 	'5232 Corscot Plaza', 			'Seattle', 			'WA',	'98102'	),
    ('Oliver',		'Cready',		'2010-05-01',	'4191080085',	'5232 Corscot Plaza',			'Seattle',			'WA',	'98102' ),
    ('Sue',			'Cready',		'2012-07-29',	'4191080085',	'5232 Corscot Plaza',			'Seattle',			'WA',	'98102' );

# 30 samples
INSERT INTO patient_photo
    (pt_photo)
VALUES
	('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAKxSURBVDjLdZNfSFNRHMc3FVNEBTWFFH0wTAVf9NEeiiLNh+ohKZIykKSHegssJXqZVFbiKsOUNAkhMu7wz8zgqjk3LndbOnVuorPdbboZsc0/zKs4+XbOdU4jPfC9v3PO73w/53cu58gAyKhIk+fl5Z1XKpX6nJycUjKOonMhRRUWFp5ua2vj6Bo6F/bRj40EjsigVsPtdoPv65PGtpBof3xwUMr9HBgI50Iby+R0MHXsGCxaLVwuF2ZINEVGwhsRIWlCLodFp5NydM1ECBCqbhcwFxcHprMTgiCA6ejAeEoKHElJcCQkwBgbC6a9fTdHovUwwJ/ERAzl5qIlIwNsVhYWMjNhT0/Hr9RUWAlIHR+P1zEx6I+OhptU9B9gPTkZv4uLsVxUBE9BAVwE5sjOhp2AFgjIlpYGW0kmZruuY76nHqYPFzDxJr9SAvA8j2AweKS2t7exInTDM1yDlal+YH0J/qmv4F6WLh8KCAQCMBgM8Pl80Ov1MI02wWt+gi1XLzw/XmBjmkFQ0GK6o1o8FEDNKpVK2nndPQSf+TF2NrTYWLgHr/4+rJ+qMNl+B9rGy6f+AVDDHoRhGKwusfBNP8KOyCFgq4TorMCapRZC5xXwQ6r9n3gQsKeej3XwGGpC5lsQHTewaq6D7X0Z5g3fwXHc0YAlcw9mBh+QsjUQ7VXYdN7ECqmEmjf9i9J9oMcMX2UKIMYdarZoujAzUIvJb01Y5MsRsFfAa3qIudZL2PS54HQ6qRFGo3EfwLIs/H7/KoV8eX4OWBMw23oVw7UnoGu5CN2rElj1rLQzbaIoSkcIA5qbmzEyMoKxsTEoqguwxb3FFq8EX38W3XdPYlT9WcppyTvQkTeh0WhAPWGAQqHQkmcMqmtnjuPp7Xywz8rQ21iOd40K7OUOqqGhgZYj+wu8wrLULIN/YAAAAABJRU5ErkJggg=='),
	('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAK/SURBVDjLjdJZSNMBHAfw1UMPhfTUQ5bgkfWQSodmYplroiAkXkvXcnOVipqsWhLKXEvnUEHUOecU72tec8vEVgQamUfeUzzThcc2QUqd+09b+u0pMxTz4fv04/d5+PIlASAdFG6wJWsk3351ofoMZstszKVs22I/V9tjf+4HPrN9z1I0lTZbizWnsTsFsXbZhwKKmadEi03O0KoiQHRnQit3x6LMCqP5dj8OBUiCT2bqhlRY/SyBeagchk4JFgZb0ZZyWXMoIND3buRY1bPtteFGbI03wTiqhK5dhGSGp3xfIJJsz8pj3V4VhZEhCaeYo0Mc+0QvYn/q5BzMv34FXXMSOqSP4RRxsdUl3uHEPwDT/Rwlj+W1lU0nY3dKstjILRAgQ8yFMtcf4y001CjC4ci7UHaJc/74DpAVcqWjMNofTfyHGKvhoppDhSiMAmmUF0qHuGh5Q8VyDxtmQw/mP9xHRhUNbtEukh1AHGLXMN0m21OYLJEMueoelj6GwbxSiZVRPpa7eJioCMBQmsf/C0tPCUanwg+b3+uwoeVhQ1+IlWEeiDk+pqSef4GjV3MSxAlxewpzoD5HRYkP1mfSQXyLgWmOA0LDBDFFRT/fzUQCQDriXvsokNNvaNcDwno5kkpkiBeVobZtAL3VUVDLQw1rkwwQ034wzdBhnKCin+9kqgi1ppFsfKVUKrvF2Dy+BcEYEPEFYLQDwvoWfCoLBzFXAOPXIBCT3ujLdl0fTHHRqwXX9DKGdRAAEkktcP7V15gLjkIHpgpgKrdBl22jqy4GG9pyrKmvgxjzwYD4Bgrodg9UQZYW7Qwri50haXJuaRtTn4LG60bke4D1FmAogS4FG5tLQhgn76A7xwO9wpvYb62kycoot9bkwERXapXS+UkvyDw1yLwRpKW+RHdRAN4Jvc1FcV4Ns6U0+n7Ab/dSu26WPRQHAAAAAElFTkSuQmCC'),
	('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAIJSURBVDjLjZNPSNNhGMc/7+/3Ww5LmRaho0AdQgWpbRUqHmohVIdBp6Cbp7DWpQi8VyRBt+jQpdNuHYLAWEEiORl0CCsbIlGH5YKFbXPE/rzv+3QYipIOH3h5eB94Pu/3ff4gIuzl5EZGZKe4wx7t1cTEjnElIpuXTCYjxhi01mx4rTX5fJ5UKkUwGCQUChGLxdRGjreVVq/X6evrA2ArWESIRqOICMlkcpuCbQCtNQCzy42fGQFjwYrFGLh4QlOtVncH1Go1RIRw158dCwmBvQHS2Q6sWLRtKNAGrBWuDGkqlUpzAMCZ7t+7tLOjuYJqtYqIMPejEyOCtmBNoxZihaun680VFE0BEWHsaP6/1z98m2P6xTyl1gLXHpwvFcprj2YeLt7fBNxNT/bsC/i5JJex1pJIJHAcB6UU6y05Wnv+cm7sLEc6+5ldetmW/vL+3nA8GNicRGttr+NzyRQ/IyJ4nkc4HCYSiZDTKwwdG8Q4hsHucYyqM3xyFOCmA3A7db0do94d9B3ibfY11lo8z8PzPBzHYa2cx6cOEDt+C4A7F54ROjwA4PcAjDaTRltZKS+r/bV2ktkZrM/iui5KKQqlNZZWF1hcnWdq/DnTbybwuy0AFSUixONxabZIP/mK25tjdGCM/q5TrPz6yMKnebLfi4+3LVMzG44Hp4EbQBuwDjxNP1md+gdPcFmX7csAmAAAAABJRU5ErkJggg=='),
	('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAALPSURBVDjLbVLdS1NhGP+d7bS5tcZYkzmzWmqKSSISpElEUEEkXfRxGRFBEA2MSC93o3TT6Ka/wECJQG+7CfrSLFLzIkd+TDsOjFg559nH2XvOe07Pe9Qy64XnfDzv8/ye3+/3vpJlWdhaQ0NDPtM0ezjnHRRBClCsUowbhvGwu7s7jx1L2gIYHBxspeaR6urqQ36/Hw6HA/QPTdOQyWSwRIuALvX29k7/A0DNPtr8VFdXV88YQzqdRqFQENMhyzLC4bBdnEwmFyjXEo/HS1sADvGg5O1IJFKv6zrm5uYWVVWN0rdLhPienZ1dEcDErp6kxLYzkMWDkh1erxepVArU1BWLxZRtNUpfX98ZRVGS0WjUrv0fQKXQTNPE99JOo0ROsBM1xLbyLw+Utzes8VQjvuc8tuaLzRNwWjosbsAyNkLXOQam22xTwxVZXNg3gcZbU9IGAzLxyuXTkMgOyemh93nApD25grbphLgObqiU6kG2mEV/VwILT9/9kSAmiULjxzPI7hAkyUcAuwBPgNImUMyBr89DY+uoCTXh2vAdxJmxDYAowhSTGNZmJknnbgSOnMDd548pz8AsDkb6I8EGNFUdh6oVcK/0HsVEUHpzf9UiAB1ChkVUA40NcLhC5IwJg5rPNl8HJxbc5DCJ5UoujaM1ncizEiaXX7OWfodLtgjdoilCa/bzNJxuPwItndAMZjcrP+ehmwYB6tCpZr2sonX/SeT1ovxhaVSzAYRWiyQEDkfh9O6l68UIQINB/oT9B6iZ22DfcssI+qowlR7DWGr0C1nRRgCMtJowDeHBDAHsASp8KBHAwHgCzCzbbGpDzWivPYePyihSsy+gcbSuPLDKNoCQ4K65Cc9BJySX2z7C4XY6CZoM0stLKk49uQrJ4UEm+xWJghPHHvHyximwMhZHemB7YV8cfTOM32+6Ycg7Vbxce4WRAt0YAby5fgEeKcjVvgWNOgAAAABJRU5ErkJggg=='),
	('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAALoSURBVDjLbVNbSJNhGH7+7z9scyqepi6JobKmE5ZigSWpYV5UskYZkRJk0lVeVN5GF96EF0kXZXRVFHWTKynqKijFQmvqTYRMcWuYodtS59zxP/T9vwdc9P08vP93eJ738L0foygKdkbb7bHLhlxdF2HQSqcM/RJQGEiSqFsNK0PjA429+GcwewVO3fmcetZbzxOqsLOs2mA0hReeNSz5EvE5rzd/9P7p5A6H7FVjWSLyLIFvlYN/jcVcmMGPFaDcZITr0D6UW/UGLtf4eC8nQ0BRw95eJAyzi99/4rBkp3H1SCFYnj3/X4H+/n4DlSBqyByrggFLU1HtPI1kMiBCx7NgOEbu7u42ZAhQcg81K9S9oKbOMUTb4CmZoxHoBBZ6CoWu0oiEZDK50tHR0aOlTQhpM5vNL5ubm4WxnwrOHDYjlqaeKFGR1VSo6qYHBeEnMBTWYsSzipsd9cLy8rJzcHDwC0dF7jY0NKC4uBgHIw9wb+B9xjXxrIz22kWYatox7r6F+oQJVus1uFwuBAKBh6qAzW63a4edTidsNluGwGbgLa1DNXLNdagqGUGptQ1FRUUahoeHKzhJkgQK7bDf79c2QqHQVoHEEAwr71BxtBNS5A1M9k6EJl5DTJ8EQ1isr68zRBRFLCwsaFCJtECIRqMUG7SDPqK46iyQmMbXp8+RnRdHVtKHec/ILodLp9NYXFzUPMZiMaiCqVQKurQfBUYeOfkx6t0HtaJS9BvKW/ow++ERopZcBIPBLQGVoA69Xg+3200rr6DRNI28E5cgxyYpN476czbIqSXojV6Yba2Y932CyiWULEciEU1ATaG6xoHjjhxU1rQgKycERQzT/mQx9cpLT8iQE16YDlhAfo2hNEcB63A4ymZnZ4WZmZmSzeou3LjQhLWJAViaroPQlmT4/SD6KpTVHdMsI1SCM1qhy7YgPzz6PeM1XhmalDjaWhc3+sBK9CXLyjbkbWz9EykZhzpXlKm/wwxDbisZJhAAAAAASUVORK5CYII='),
	('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAJKSURBVBgZpcFdaI1xHMDx73POs7NzbMO25qXFGikRkmQXLuQlL3GpuHDhwkuSC1dKaQp37pTszhWFFJFGLG1cuDG1cyHKsnm3tXP2nGf/5//7/36myI2i9vlEZsZM5JihHDMUn7351fgLUcV7xYngPaRipE5wXkgzI/FKmgox0zYsK/GHIWqEYIgaEgwvhlfFe8OL4oOSidLz+DMxv1RqQlAQNSQoWTC8KF6MTBQngcwbTpTMKy2NMemkEDNtx5pGegerbFnVyEQtcP3ZOHu7mikVIoxpBoPDNfrKExzcNB8nytW+L2jqyTkRak5pbsyjCvV1OdIsUCpEXLz7kQjovvGejrYCK9pLtLcW6JxXJPWKJkIuccLzNwnrl87i9otxinURh7e2EecjJl3AgMQFVGHj8tn8VJ0KOB+wJJCbTI3NK5p4MlRh2+rZ1Jxy/tYozhvJVMAMkqlA5eEVysdXM7CzyNCRZSwt96AuI55IM3wwnpYrrFvSgBlMOsHMSFwAg5XD17CRR3TtP0R950rSV700DTxk0GpEW86Vbc/aZkbGHJlXnCjOG5koTpRMlAP9u9h99ASlt30w2g9z5vIt7uDBg9fElaqQZoGmYp6sLqLoI3y9IRLhJYdXoyX5QHFBJ+w6yW9x90IW8J14LPVcuj+KeUOdYplgXjEXIFMsKFsLLdRe3qPhzjFc+okaUK3k+Ra1EpkZ/9K/r7270NRwelGrxHFuhOpX4d3nfPBTdiYyM/7HwL7Fp5KxD0fyIeoIeRs1uLy9Vy78AKt+cH41HYv2AAAAAElFTkSuQmCC'),
	('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAJ4SURBVDjLpZNdaM1xGMc//5fDZqTZ2c6Y9mIkmZelll2hlCVF3FDKlZRyQWJXmsKNCzeLcqdE5D0mL/M2s6HlJSlhs2Rv51iYOZ3z+/2ex8X/zHZJfvX0/J6b7+/zfH/P46kq/3NCgNNt3w6ost2pzBYRnIAVwTnBiWKdTAiHs4oTeX5467y6EEBUd22qmxb/l5ebzn1Y/IfAicQBCi7uBFVwFsSBMdE9mwGThYwBYxhtvIcxbvIEgTEfFGYVg9go1OZEMmAyYLPwth8AY924B85JTsCDviSoRCQiEYkby0AiAUA2J4Cq0nyzX3+mjZ5pG1RV1XOPB1RV9fyTqL7QEdVXOqOc/J7Wbceeq6pGBMYJokoYwMWOIYLA51LnEGEAV58N0T54iEdXBBUh1tXEgrIpZE1E4I+1oEAYeGyqLyH0YePyEmI+rK8rwfcC5lfPxfcD1i5LRF9rZdwD4wQVCH243pXkWeooT1sUVSV8sR/f94i13KHh1Utam0+iRaUsKVwH1OcErKCqxAJoqC2mowXmVFTS3fuJhtpi8p6WUTTcxbyte5lctZD069tMb2vlzurYLh+iqQMIfI+7r1IA9PT24uFx73WKzP0TzF2xgbyPD/BObWFK92WqKgpRT3eHANbayAMfVi2KEwb7WFkT5+GbFCtq4rR+/UxeaRWs3TO+A00zCcSrHPdAlZryqfQPp6lO5NMz8JOywkm8+/wdnZHg18sbFFzbSSY9wC9g5EeAC+jLDZK2Hzz7fmnWSYGxDmMdzgrGCdZZ6ks3MrXzFhUz8gmDGCNJS8+gr4oc9/52nds3lzeODvftCJxX4QL9onBizW175DdAmHVGgBeCfwAAAABJRU5ErkJggg=='),
	('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAKESURBVDjLfZNLSFRRGIC/O3Pn1cyUlLXIlB6SQrXo/YSiRSQDualVUFZE1KJtrTKHIloEbQpqYUW4DipSehBIYWr00MIs0ckUR6Z8jqNz7/nPaTEqI2E/HM6D833n5/znWMYYZuLglUZz4lApTT+H0MogohHRaNEopdmzZgm36z7w/vZha4axyQstgtYG5U6DKteLyjWlDKIkH8GTP5k9zRWUI6xzP3PKuYvrCK4rOeH/BFoJExmX5dEAriMcMK/YER6gaKqb4kUh0pksIv/NQOKt7YMUBmzWRydYa36gl+8mZjWxLOyn+WMfWkl8XkHj9YrqL99T8ea2JLtohTWVSOFWNjlNtHz6SXtnMt5RV1Wdz1jGGHi4O4THW4bBC3ChM3bm/Op3pws3H0dcm8CvRzz8oJ9UlSZqyG0BNZXi5JvenODBtj4WlxcZLDAGjEaW7SRrr0Cnf+NVIwQyP7CmhnJJiwvpATxjw8dygmvFh1CmTu87G5HSI+ixFGrsN3o8hc6MYJwsGI3lX4AXhd3+lGBP12PCvqPW7EO6VFSK5qneXlmWLalEhpNIZhidGcVMjGEsQ0ANEfn4Ukirau4lr869xHh/FxHfFs+3hkf2yFeMdjBTE5hsBq0msX02kY7XQzimYgb+pwpcTKQpWPjCM57AKBeUC1rAne79dpo7/S/mLSMA3mBMCspzQ58i6B3FEypAdABZvLSEmvIN8wtqd4Qw1n6JrCTYXU/0eW3Xgrf196OpZgLecdTCVSBWbH6B6L0SXhHyPbuMv6XlLsps5FbfCd9Ab0X407N+MzkJrpkjmPMbGR0p8n5P9vDHOUftYMPs+o1EAxfL1gU7224ibMtH/gIKIWcO8vV/HwAAAABJRU5ErkJggg=='),
	('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAKZSURBVDjLjZJLTBNRGIUxbeOGNLrSaFxgdOnGrS4MijtWLkjcysLEuNEoqDG4IDIpNCUlLVLbQFrsI0Dpg0IfIzYiCyRQA2mb0tQG6QOqbemkFanY438nofFBCJPczOTOfGfOOfdvANBw2PJ4PHKXy+V3OBzcxMSE9N/3R4EDk5OT5fHxccFms3Fms1l6JIGpqSm50+lkcGVzcxPlchkE75pMJm5kZOT4oQL7sN1ur2QyGdAzKAIEQcDw8PAvvV7vHhoakh0o4Ha75fQxvw8z0GKxgOKgWCyKTggWtFotNzAwID0QprIq6XQaZJ/ZBjnCcjwNlScMx+I6NBpNTa1WB1Uq1Yk6TGXJCeCpLBEmBxgdHQWJIp/PQ+OLov31Ah6alvEllQHBQl9f39UDYXIAKkvMnsvlEAwG8S1fwDNbCLb3Ubj4OfT29lY5jmsWBehv/NjYWHVrawskAqPRKGZnMIljdnYWyWQS4VgCb5w8g3cJvlwvkWC/1WqtpVIpxONx+P1+EWYOpqenkUgksKTrwrvb58E3y+C9Kcv4WiSddQFqWVhZWcH29jbW1tYQi8VEB6z5SCSCj6+e49OjK9jxKFGLeFGxPsDivUt7/uvS+6IAlZWdn5/HzMwMCoUCotGoKBIOhxEKheC7dRbfCYa6Feg4CbxswlfFNfhuSD6LAjRZpwwGQzUQCIhHx1ovlUpYXV0Fz/Oi7dqSHX9exa7TtC+t1Y9Rp9M1Dg4O5lhmdoQst9frBZW1Q5mzZcMdgKAfjxtQoLV+VwLqIfXXINFkNfb392dZflZgT0/PTnd394W5tjMvFtov/sx0NCH3RIZE+zG8bZXueVskT/8bZaVS2ahQKLIECwze3//Qdq6T/phktum+wWC2/xtU6N71e0LFhAAAAABJRU5ErkJggg=='),
	('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAHXSURBVDjLzZNNi9pQFIbzA+YXDP0zLV3Nb3E9a3d1JQh+g7oQLaKCimL8QGKiMdF0OjUTjB+N0fi9Ghim7aa8vScwglBKabvohZfccM95zntObjgA3N+I+2cARVGuJEnydNjief5LpVLpFAoFTyaTufotgCiKtw8POizrMzaOjfnMhCz3kUgkbn8JkGX5utvtelut1telNYf+ScPHDzL0+yEW8wnC4fCT3+/3+Hy+nzrhBEHwTiYTvCRrQwma2sVIFXCnDaAqA7TbbdRqtcdSqZTIZrOvLwCNRsNY2RbGrKI2FN1kddCB3OtAFAU4joPT6YTj8cjas5DP58epVOrtGcCGZVD1+zuFJYusYh/9noQe03a7xW63w3q9drXf77FYLPCerTOA7b00LMMYYzRS3YDD4eCKksmBbdtYLpfuk5zkcrnvyWSyFAwG33DMzjUblJcNymDtfKMAqkbBlEwu6J0AJNoT3DRNRKPR6sVE2RUwCUCJq9XKDd5sNmfAixOaBbUTj8efLwD1ev3dbDZzDymR9tQSuSAgfa3pdOqe6boO1gJ/AWA371W1Wg00m801gznlcpkvFoutdDp9CoVCx1gsJjFpkUjkORAI8KztG+7/+Zn+VD8AV2IaSQGFiWoAAAAASUVORK5CYII='),
	('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAIzSURBVDjLpZNPSFRRFMa/NzPaPNSpsDQVF4JUi3YtomW0MBCchbSxhS3chAS6mJpFBYmugpjSRS5cWAQFSUmBGIYiCbYYbOyfOAqKgwgqRNF79953zzktxoEspyAvnM095/zOdy/fcUQE+zmhYomOl23J9mcXw/8N0J5u8z09+C+AU3hC58Tl+kDbVqODpkCb09UVNUeNMciuLt0b757q+ivgyuv2s4EOrteW1cZj0YOIlrpw4ECRxvsvGWSXlvpme9M39gKEN84s1xtt+o5XnojXHapDAAsWxpa3BUcc5NZz2NzYfLf+NV567lQs+8cfKN+0HnNr4pVlR6CshlYai6tZGN8inZnD4kJ2YO7ux2sAUjef5NzfARHlqabyynIoq/DN+47x6fE1rYKRQJvzRgfpD/cXrgIAszSySAJAz24Fnr7wNjOD529eYGxyDL6nR2Z7093KN0+1CjoKhcwMIk4mhlcadkkQkaLxYNJvGJjwRkUEiYcr0v8qJ11Dy6O/1uzpg6Fp5Q5OqVuW5JMlaQEAIoYbBg6XhVs6BxebixppaFo1W8Z8VYVz+2R1xLWU94klxg9FiIYBaznV0f/ZBYBIoXF4RjdYklTMdVoqDjgoCQOBFRDn89YyfMMgZlTFShrXtv0EgJ7I41njWpKEJUlWx0JueakDQwITACQAcV4BEUGZEAqKiDh56U7mUcSSzFuSRsvA6jbBksBSfjKxYKcflhgr2wpMvHMvLrOknP2u80/X2WfmmbX8IwAAAABJRU5ErkJggg=='),
	('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAQAAAC1+jfqAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAACmSURBVCjPvdCxDYQwDAVQSxQ0NFRUl4ouHVV0TapIiIYCKRnEE2QCNrgJ/iIs4jW4KOR0qSiRK+s/2U7opPuiR4CPHh5bOGkJDhYmnqTnca8meNlwtSmWFL9HKKnAJmsBBlMOFA81WGU5HFs2PB06BwP3NVjElQkaYw567mrgxBbw291xWwMrpgCFa3fLzR/YmE6DTs9UYUCPLrah+RBop9dTX31fX9NT9CS3ZDF4AAAAAElFTkSuQmCC'),
	('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAJ2SURBVBgZjcHNb1RlFMDh33u5c52BTmtTipkSS8JXFF2YRumYsGxYKcF/wUV3EBJ2LJpAoomsuiG1bibR6JbEuHNFw8JqTYosCK3Ur9IWRuidzte977znHEsyxq6kz+PMjP2o1Wofm9mnqjqsqvPT09OX2RWxD7Va7aiq3piamnptcnIyEZEKfTH7ICLvj42NHS0UCiwsLKSqGs/Ozn6jqk9j9kFEnIiQpikiUheR8xMTEwcXFxc15iXm5uYiVb1SqVQIIVCtVk+VSiVarRYhhLp7+N27y8XBM2eci/iPkTcf/fV9b/521xcvHYk3k4nTw2xsbFCv1/Hes76+/lhVZ2Jn0Ruvn6sVnHNg7DJwjh8fPDneuJ9ffXP8EEsrsLP8G69mP0hlOEs3t7e+FBn/bGZm5olbuf1eevLDhSG/NYf4AxAN8vPmae6sjfHOiUEKBag3AneW/+aLSxVcNOBXvz23euri4tvsium5yNQjPsHU+OmPMvd+7/JB9AmHlu7xwnFgMoFf53khAd6iL8ZZUUOX9uZT2mtLHGgd5sLANkMXvsbU0ex4SgmMDsaAESVDrN46y79iehFx6Qij1WuMVpWRrjKQtFh5dJdnaYtjw1sMFevkO21MOxTHr7NXTM/MJEM7v2DSQNJVfCGj1y0zUsoYKTWwkGLSwqQDpuwVk2OmAe3VsdCg9IrDQs7JkTZYDhZh0kZDE5MmOMdeMd7MIVh4joUUCykmDSw0MGlgoYnJDiZtTDM0/5NdGX2xed0OnWcHe62kjJYjswJoGewwJjngsSgHPC4SJMvMvOb0xZblN9c+/+gsxhSOMv/HAHfXo/YVff8AB5pkhgXUuFcAAAAASUVORK5CYII='),
	('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAInSURBVDjLnZPPS1RRFMe/b3zk5DCVmlq+0ZBCoTEXWkEELmzhqiCocNWyTav+gfoX2gq2bhET/VgUIczKoVUGxthIKqX1tAmG+cGM7/56nXvezDCtDC9czpl7z+ec7zlznxOGIY6y5p/N3ZVKLcb+J/j+23uphczt6x3wLYKfe0Nne53DFBB8QQiZFkK8FFLNSynjBL86MzDY9X13t3qoAoJ7Cc6kBrwYwR8Ifn3OSzFM19POYu4xSzAmpG2gaRutQYFQStOW+H1Qhh9WcTKZRK1exy9/D+nEEI4hBjdtPAwPX2pXtC2FoWlu6yv2Pxe/YulLBk7o4MnVBzgdP4H19WW4LTAIqgxYFRGsyddtez7ej0cX71AFg+NaQWsJKRtRAgtYsKfnFEZGplGvl7C/X8Do6BU6l1hbe4PJyZuY6nKxsZFFqfSDz5UKELM92grGKIa3tz/SxQHBl7G1tYJa7Q/Gxq5xcKGwTEX6eC6RAkqgteI+7YFdlYqPzc0VNBolTEzMIZHog+/nkUwOYnz8Bsrlnxxri9pCMWMa0NyTTQS+tBXy+ffI5ZZ4Lp43hWz2KXZ2PnErVn7EBHCtDCtfa8FDmZlZYGlC1EhuP99VKnuYnX3IfrH4jeGobQ3X9hZlE1hdfdGeRyug85+wtjXwyCq4QRCwpO7uREewafqm/bv1LujJNW30CZCCBvX7jvtWys4hIGvfg+AkkVzFQGT/Xc5RP+fW+gsEgchGXj0/PQAAAABJRU5ErkJggg=='),
	('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAANPSURBVBgZBcHdT1tlAMDh3zltORT6Ob4mtWDGMpgiU8LcEooJyiaEGbNkCkaNCVfeGP4Dr7zBG42J3hiVZInTeTMvFAPBYRhmGDBjEYaAMhhtVzraUjin5+M95/V5FCklAAAA4wtjfcCHwHmgAfADh8Ci9OSXn/d9+ysAAIAipQRgfGHMD0wC115PDmjxYANloxbDBuGaCHLMZqeEK9wZIdy3vh76/hhAkVIyvjAWAG731D/XeznZT9nUsLDZKitUSY0Dw0MKmyAGWWuepczSfeGIl79789ahCgBMdted6U0191BwbRxVQQiViqjCoIqCpbFvBtk7DNASeomek+1dtuXcAPAVL+2mgE/eOXPF97erk6VCxRMcmyEKVoCyCZvpIw51HS1+gBLd5GJ9B7Nrf566vji54rsw9uKnrzVf6FR8QbKqANnIU26I5ZyPiqmylj7Gqy6itf6DFdkk7xXxF10665Lq8sP1E37gfDKS4J6RIV+t8qyvDQ/Bzr6NaVaInpSUT0yz5ZXAksSExmbeYuCZbhxLPO8H6mr8tewYGfYtg3DNKUp2mGLRI9pg0hg3yLsvULZW0OQRR08OKJRqCAXDOLaI+aWUiiLBtspIkvgDLlN3HZRgiOyWQJURmhsqhI/6KKcdTJZw7G2QEiGE4neFVyjb5USdL0a4+hw7aQ9lZ502nvB0Yx3rd7LcpwNHFZzzVuloaSOTq2Zx/gGeJct+4Yi/HhZ2E6drksyk59H/OKY7mGBk5D10Xadtbw///CK6A++PXqO6KkA2m2V5eZloNm75ukbOHqzub789fDql3p6ZJb4f4sobV/nos6+4deM629v/0daSwDrM89vsLDd/vEnRyNLfd4nibimgfjP8w7RtOb9Mr/1O+CBINBwFIHZxCMO0GB0dJZVKMTQ0xODgIKZVwdduAhCLxlQ/gGM5785t3rtTT6SLfA4A4+5PKNJjYmKC2tpaAHRdR3qwMvXIGP6AmnQ6bSpSSgAGv3glbKTNnyP/xlOv9g4oiUSSgOojl8uxsbGBpmm0trbS1NSEI5zS3qM95ubmHitSSgAA2tvbfY399eOhx5GPmxubq7UqTVFQeKCsllyfu90pus4qKFiW5WYymbyu61f/B/q4pKqmYKY6AAAAAElFTkSuQmCC'),
	('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAJrSURBVDjLpVPNS1RxFD1vPpwPefoGG+1FZllWEkZSLYIWpiiJSEgt1VUQ/RXSMmgx4LLQRS1CgmpT2DLogz5khoTRwKaiMckZmtHnPN97v4/u+80M5SJc+OBwNr9z7rn33atJKbGXL7Tbg4WFhVnG2LjneSFiECu4ruvzQ+1/CTKZTDMJ7hmGcS0SicMhEYSAek2aRMLA/PzzvwmKmf4BycU0ISh4uLGFN7YFtEAIqxyOG0YhehMeDAgpyEiCk5njOFWDYro/KIW4Gk2c7w6Gk5AeU+CuDfv3EsrBS0h/WiGRpBBCYXBoWLWhDKhqO2E8HOsAK39AINoLzovYLn1GpfEyNitn0H0KqrqsVfdbVwkKH/saSHw9YpzWgSCEvUajdVD6/gIiOQHRPAhh/UIm/Z4qc1Wdcw5z5Eo1geC8VzJxI6J3QTKbPEzQeKkSmVXykJszaCqVcKE9Bit2EV4ooVLI2gwCJJ6OtpzbZxeXUCksQ4scU3/XMAcQd3KI21nECs/gch1Mi2Fdz2GmlAKNspaA8bmt/JuXxB4hLNnrSaNjLMm2S3ArBVjyMFbN22ChVjWDmeW72NpkKoVvsGMPvj7taZKM/4w2nYxXymuQ5ji2jT78yK+ryELKGgOH2k08uD+7cxOFxx83xA/Ev61xnBiew8YWh71hQXB/6nUDWWVZbSFQF3951D0sPNZpF3Nji87ou1dv07AsC7quIxqL0AZqyojXUvjJ/ZUO/VM9Txg9Prmy2AU8SaVSI9ls9pZpmmePdB5Fa/KgEtRb3t+WhH8b2m7XODU1NUTCO4Se+jH57IP2YUnb6zn/Ad9Qrbi4Y2W9AAAAAElFTkSuQmCC'),
	('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAJBSURBVDjLhdKxa5NBGMfx713yvkmbJnaoFiSF4mJTh06Kg4OgiyCCRXCof4YIdXdxFhQVHPo3OFSoUx0FySQttaVKYq2NbdO8ed/L3fM4JG3tYPvAcfBw9+HHPWdUlf/V0tLSqKo+EpEHInJFRIohhDUR+RBCeDM7O7ua55QSkRfVanVufHyckZERrLV0Op2Zra2tmXq9fg+YsmcAdyYnJykUCke9OI6ZmJgghHAZ4KwE3ntPs9mkVCohIjQaDWq1GiEEAM5KoHEcY62lVCrRarUoFotUKpUjIL/y/uqXYmV62ph/LSVrr30P4bEFcM4B0Ov1jk547/uAUTs1ceNdZIwB7V/GGHz6+9LXxY96eDiEgHMOY8xJAK8p4grZz5cElwNbwZgyxYu3EFM01lriOCZJEqIoIooiALIsGwA9Y1UcwcWoKNLdpLu9zvbnBWqNBhuvn5EDUmB0EH/1E2TZw5U+YLQovkun+Ytsaw1xCbnCOap334LC7s4Oe/ttvA+ICLmhMXRxDufczUECS37oAuevPwUEVFFp4/eXkXSdYc2IopSepnjtUh5/wg9gfn6+OQBUNaRIUkfDHhraSLoBKqikIF3yHJDLHaAkFOLciVHnyVAVj/S2Ub/XRyQD9aAZKgkaOohvo6ENgykcA07VEFDfQv1uf4W9Y8y30bCPhg4qKZJtMnjTPqBO/vhkZ7h3EJeRslWNQMqgY2jIAIfa/m5sIKSpqpPsGEiz599e3b+GchtD+bSvjQJm2SG6cNj6C+QmaxAek5tyAAAAAElFTkSuQmCC'),
	('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAHdSURBVDjLpZNraxpBFIb3a0ggISmmNISWXmOboKihxpgUNGWNSpvaS6RpKL3Ry//Mh1wgf6PElaCyzq67O09nVjdVlJbSDy8Lw77PmfecMwZg/I/GDw3DCo8HCkZl/RlgGA0e3Yfv7+DbAfLrW+SXOvLTG+SHV/gPbuMZRnsyIDL/OASziMxkkKkUQTJJsLaGn8/iHz6nd+8mQv87Ahg2H9Th/BxZqxEkEgSrq/iVCvLsDK9awtvfxb2zjD2ARID+lVVlbabTgWYTv1rFL5fBUtHbbeTJCb3EQ3ovCnRC6xAgzJtOE+ztheYIEkqbFaS3vY2zuIj77AmtYYDusPy8/zuvunJkDKXM7tYWTiyGWFjAqeQnAD6+7ueNx/FLpRGAru7mcoj5ebqzszil7DggeF/DX1nBN82rzPqrzbRayIsLhJqMPT2N83Sdy2GApwFqRN7jFPL0tF+10cDd3MTZ2AjNUkGCoyO6y9cRxfQowFUbpufr1ct4ZoHg+Dg067zduTmEbq4yi/UkYidDe+kaTcP4ObJIajksPd/eyx3c+N2rvPbMDPbUFPZSLKzcGjKPrbJaDsu+dQO3msfZzeGY2TCvKGYQhdSYeeJjUt21dIcjXQ7U7Kv599f4j/oF55W4g/2e3b8AAAAASUVORK5CYII='),
	('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAF6SURBVDjLxZM7S0NBEIW/fWCnQgyIT0QQDKJBFBRbsRCt/Ae3VRs7wVpIY6WxkqTXxgek8IGIIQRsYjR2SkhAMJoipDAkXNfi6k18YcDCA8vMLDtnds7uCGMMf4Hkj/h/Ag0QDocngVVgrM68O2DJsqx9/bax7vf7fK2tXgCEABBvftU6vuDxMd97cXEZBFwCr8fTTCbzQKViO71J6SYJIdxYa01HRwuA123BgUAphW0b93AtSZVAIaX6qMF7RaU0WvMh4bNVSiKE/EoghEQpiTH62+qJTIzLbIzic4FypYxXdmuwEKFQyPT0dDE0NOCKVxXMiU8SB6Seooz4Run09HGa2iV+fU5Tsd+5QTqdJZ3O/vhmZ7lt5mamsaWNv22K45sdxgcn2NmLgDHm1zW7Mmwi11umFvvJoBlbaDN1/cR8IVdK3ccIHFkABA4tbnNJgFJdBC/mZS2ejNGA5uBqkwahiSbOAIKi3nEeX2wPAPNAI1AENuMb98uviwGZtIAuD3IAAAAASUVORK5CYII='),
	('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAMvSURBVDjLXZNtSFNRGMcvgQQRfYsoCD/0waI3ikqzIoTojV6IgiwrtBejzGRlVGi1QaHZamZpaaalNnPWyjmNlrZ11dnyZc6luWauXNmWm267zvT68u+cSy3rwO/e5z7n+f/Puc+9hwHADFQwkwhigonwjjCZ5idCcjN+zxsIIX/yTL+SCSKkDTREfeVdWngb9jkNqq21iVW8juD+je6tagfrMx5zDbYnu0m9gTBbMHAWM0lew/5vw44K9NbH9DcqwrnUWhduNzhxv+W7AI1vsF1oUSz1e8wSP9dy+gfRNRGCGPsD5oLPlOx21MT064vCRzLqu1Fi6oGc/YwsZRsyStvwoLoLcuNX5L3R4oNqw9igvXTU8XyehWhDmE/ZzJqOnCmWutxF/jRtF4oN3VBqbei0e+Hycuj1DsDS7UWhphN5NTaUlElhkocNtedMaybaEKERiffLr519akZOrQ0KshodfR4PPn77jp8kpnDjwF11J7J0VlxUsDier78i9IBeorKbdGeemHH3hQXtZGX/yDg4vx+ZeflwEiPf0BCevnwN9qMHKYpW0FqqCRjsSmfdInkzrj4ywTnIo29oDMNk4rxYgiJlGc5ekkCjN8Ds4XEqywBaSzUBg20pL9yxuQaI843o5nhiMga7x4fL0uuCmDW2oncEaHTxiE+vB62lmoDBxotPdJEyLSSFTXhj9aCHvLTdx6NSV4cutxeOUaBEr4ToTjRib2zHnivrsSkp1hYwiDjzULxZ/BwJ9/RIVVjQSxrWxwO+MQKJS+seQ1IaA/X7TLT0aCB7dRy7ZQsRGjdTKhisis9aRmhbf6EcomwWVxUdMNr6wZF+cH4eMWmbUGZOR1l7hvCFpFVHIKs6Sg1+Bv71FUekR4+lFvrXnXuGA9JXEN1ikXizFiJZDbYkLUHl+1xMHKrWTGrw97Do9foIs9mMai07uiouF8tPyBGaoBRYeSIY1zQHkaKJFsQpL6P/3YFarZ5O4KxWK1Tl5e7Fe5MlCyKTdAQ3ZemhiC87pXNxXXNYWJne6XOgBwUFBVMJHYRhwvz/jzKFFKeGxc0aoNtefTJ4fG3CnFs0/wsC49wP713enQAAAABJRU5ErkJggg=='),
	('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAANCSURBVBgZBcHbT1t1AMDx72lPKS29UCiz0BUMQxwwJptMSIAZzRgu6oOJ+jKjkQdjTAx/gI9mezAmJkb3ppKYqHsxe9oMOh0ZODd3xYVtFOLK1dG0pYWensvv4udjaK0BAACYmp8cAz4GjgEtgAmUgeta6XNfjn33CwAAgKG1BmBqftIEpoE3X8+cCCZCLVSsBiwXhLQRPOHy1iUhhfxVCPn2N6d+2gMwtNZMzU8GgD8Gk30jJzMvUbGDOLgsVwzqdJCCpdDCJYTFlnOVm5s3F4Qnjv/w1oWyDwCYPtrcPTLaNkhRung+AyF81EQdFnUUnSDbdoj1coD2yAsMpp497DrejwD+0vjqKPDZ6e7X/PdllS1q1JRgz45QdAJUbMhu7FKuVgkmChjxLMPJg1xevNH5/fXpe/6hySNfTLQNHTL8IbZ8AvQ+WmWEW0/81Gwfixt7qPoSwY5HOLEseVXCLEkONWd8tx4/bDKBY5lYmrvWJvl6H73+AygEuW0X264RT2kqTTMsqx1wNI0iSDbvcOLpo3iO6DeB5rDZQM7aZNuxiIY72XGjlEqKeIvNvoRFXg6QvnMOaVfJZw5S3AkTCUXxXNHo01obhgbXqaCtVkxPcukvD6M+xNayydpqjDYnhPA0+5M9BJfv4Nk10BohhGFKoYoVt5Ju9jcSrX+O9byJ7QVoVR8RD0ucDY/dnCDd1EVPaohdu8rC+u8UqxNIocqm8MTtx8XVdFc4w2//zdMY7qLOn0Eol/G+95BaIZVEodksr9G/f4Q9t8YnFz4Euh/4PFd89fPDWdERacG0NigX/iSRcLCFi9SKXCHLv4UlVvKL7NQK5IorDGTGeCb1PLuBe6O+b189P+M63sWZxVleTA8Q9zeQiChsYSOk4KlYO6lYB63xTgL+EC3RNLfX5rm2csOyXGImgOd471zJ3p1zau7hiSPHebRt8o9wmL72Oa5ysYXLgWQvw50n+Ts3x5WlWScs23uWz2ZrhtYagFe+fjkqPHFeeHL83ZH3TWQKrcMYPoNkvMKnF0/T1zrM1aW53Qbd3rtwZmkdwNBaAwAAMHJm6A0p5AdSqn4lVQIAKO/47yeFIlBTMrB9VgsAgP8BON24AjtZfcoAAAAASUVORK5CYII='),
	('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAHXSURBVBgZpcE/S5VhGMfx7+8+T2VI0SDVKvYSrKE/0FsIwgZpCFqiISSiIcoigkIosWyrOR16AU2NETSGZUQoiNYgBJ1znufcz3VdeUvOIX4+igj2QhemFq6fPT/+ZLMXwxGAO+GOuREeeDhhhkcQZpg7h/fn7tLS2u23Tyfmq/Ez43P7hobTsSF2Y7jbszlgvurlSL3NP+xWP0diSxUWPJo8wW5dfbxCUUU4xaA1AggPzMEJ3ANzx9rA2sDCGVgwevwQ5kZREUGhJBRBJBEK5CIlISUkQ52g44mqDQpvjaIyN4oEhASCToAL3INOQFKHSmAKLDmFm1NU4cE2CSJIQEggkCAscMHsp4d4G9w4eY/C3SiSu7FDEkgUCUgSqhIzH+7SH3TpNr+ZfjdF4e4Uqc2ZbRKSKCSBhHnL/fc3yblhbGSM0aNj1LnLlVeT5NxQpDCn6AACJCFAwPOPM/zcXKeuG+p2QN02HNh/kNWNFX6lBYrk7uwQkIAk0ZG4dfoOry++YXn1G02uaXLN8vdlZi+/ZCRfoqjWfqwsXnuWJ9wMN8fMcHcsZ9wdj6B/pKbfNmTLbKxvMD37hS2LbFFE8D/nHpyKpsnkOjMYZD6/+Cr+UUSwF38B/pkb32XiUiUAAAAASUVORK5CYII='),
	('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAQAAAC1+jfqAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAB4SURBVCjPzZChCoAwFEX3GSbBLzMaDOblBduqrAlDYcKCqNFiF39Gp8iDq91plhPvgQOXgX3D/iRM50gDWdKkSNJDmNJxHmbb6kN10gjjTdhA7z2kE6E3cc9rDYsC3GWRR9BbhQYVSuRIFo+gICHAkSFB7H765BsXhQcRTCg+5ikAAAAASUVORK5CYII='),
	('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAJOSURBVDjLpZO7T5NhGMXP+30fbalAUVtBbmIRE6RgFdIoSuIlODkYByMx6oI64ECMs4uk8ieIE8YmDu4OEIgaMKBUKSJRwCBgmsod7OX93qsTAwmICWc8yfnlyfM8h2itsRsZ2KWsrczzHd/PmRaaHKbhYVxzyTUhgNte4at0xX4sbJmMRUJ6W4ASen+gfE9zpc95WCkFIYH4EhcxluxJ/dZyI7wtQDI9NL/Cp5wG8UIrUwkY0S/rz9cTtG3kRT3dcQdEqBtF+VmNY9OZnpHx1Ku9btMl0oJ87toc3nKC0w9G/dXHcluXV1lieSb1EkCAcQVoI2fHK4RaY6bb4+hwWsQ3PrL2hCXZa0WlS0qN4/Vt1+52ndT/BBDo5qOlrsuJRT4hbZXQQpVbDlJIANhSmCXeKlzvrNoEIRuPVNcS9QWCnq/FXqcvNpUeq/TfCUgpNNcCXEhStK8CtSVn8eFnH2K/BgUVzPHu4bK2AODErWHiKXCFyw44fT29888GO+vu3Y8w3RS4TaRWkEpCQSO+NoeakjNIsowVnX3LatsNhxW8+dFNTNIQCua1TM3RpdQiiwAAFQxSK8wsTYIrAaE4uORYt/8gWNqIJE9bQ9P91MjOsSI1QU/3wiIDzUiilbpy5GJfPhUUQgoU5JWhMO8QDnr8yDKz4cstxqe5AQz86P+WZsgn25Xp6lO/pIyBKQYqGCq81cYp/yUMz75H70T3KBMIxcPaJv/bxkC7sVBfdsH7ZqI3yhQa4mHNNl1hJ/kfkQWpTG9Gyaz5sBYb/l+aZznkhSoxiAAAAABJRU5ErkJggg=='),
	('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAHqSURBVDjLdVI9ayJRFL0zkZ0ZPxoRFPwF6dZimcYm5W6z+Qspgk2aQAoDwSKwYGWvKyxsq4VlmoUVJBCQNAEJW7swUbDQcdR5b97svaMv+8yYB4d5H+eee96Zp4VhCHJc/DoLvxx/hsfZPQShgEAEOwjggsOnXBl+9H7C3eVvTdYkQBmccRDhlkyFXIjd9z98n6slbwTwkAyxIFBEthAoFp1t2J6Ari4YChiQBEM3UYSDH7AINDeOLLDCNHLY+w5Q4Pbv2KmdZL7Ch9AEjenABAMvWMJCzOHP03PEeVfg5uO3sed7bjFbTNN6a3sb8nq9Bv+FuVel67Fao0nCaDSyOee9fD5fWCwWsFqtIgGCrutgGEaEfr/vbDab00ql8rCXAWOsmsvlCvP5HDzPgwCDJJAAnoHrutF+qVQqoJtqLEQklckNdUYnr90JUmy5XEIqlQJ0UI5l4Pt+lsiyWM1AXe/yyB4SeCWr37dzAjqIvwPcnMlA5d2lfTnXNC1ySNxDAgO6PyUtu6qgPcuyYDKZkNtBTADvVR8Oh45pmpBMJvcyoM4UXiKRgG6366BAPfYOaLTb7XN0cmvbdiGTyUR70s10OoVOp+Pg36o1m83vBwVoNBoNG0Wq2KVMf4bCxaIZYoCot1qtB5X/D8V+vgtcQDdeAAAAAElFTkSuQmCC'),
	('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAQAAAC1+jfqAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAADZSURBVBgZBcFBbo1hGAbQ83+5kRCJhA2IEQMrYAPMxRZMbcLG2ICRGTeUtE1jpr1p3/95nLMV8PnL3eOT07Pr79f+/f34GuAAcPfqgXseunlx6ysADsfC0+3k1n03ODP41oiX2+IReO7KH7sfLr1HPBEsCOKNc0cXPghGDFZUUPHWb+/UIKpYUUXU+LRFBbsYLCqICkbsiArWroKIQVQQFayIYFRQFYwKVtQgqhgxiNixooJdDKIgCtaIHVFB1KAqWFFBVDCiiAoOuzMwfgnqpyCOYCsAAADgP4mZnXDW2crZAAAAAElFTkSuQmCC'),
	('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAJ7SURBVDjLpZNNbxJRFIb7A/wF/A5YunRDovEjalEXJm5M2Ji4aFoTI6kxjcVaCGOJYtq0NlBJ0AS0tcbWSkeQhhQopQwfAhYotAwIAwPDUI5zLh9SdedN3kzmznmfc86dc4cAYGhQZ2ZAJkkhSSlJ1ZWyuyf7M37QeEqSfOxNWW37uk+5fVF6Z3ePDQRD7KY3TL/eSFAj1qIaYzD2BKBrPm1xZjWBvTiTK5SB45sgHreJKjUBMvkiuLxBZnY1rsHYHqQHkKM5GP7O1Rsi4OKFFhS5JrCSqo0W2eN4ATY9fs60HEGInACwLywbM/fMR2UB9gt1yJUEomypAYk834esrruYO4s5bEeGAIWN/kFh2YNmldZ7wjw8uUX2cYUTB2Cwuin0IkDp2o7Q2DOWmjqqw6WHTgLIFBsQz/Fw7p6DAPBbuSbCYYmHuSUHjV4EqPw7uyweVv6nABfHP0vaIAbMfHbMLskBVx97yDtWIYjHsGheYtFLAL5AkAAKlSZcm/LDhQefCACBlx/RcP7+B7gy4SbVdKpowtz8qz5A+WUrRJe4BlR4EdKs1P8Tn9TCNiQPOwaEDU96IXZQI38mmi6BwWTut6Awr8WoVKYA7TYQA5Z5YzpAMqKw9OtP/RDJ1KDZasP6txBojO/7hyi7azlSrzk9DFvunDKaMDtmjGZrxIhPTBCTsuufLzC3jNHOb+wNkuFtQGP/6ORyxSoJLFVFUg2CcJgwczRdBJ3Jwo0aln8P0uAoa80ezYLVzrj9MUjlyuRMsOdQkoUVZwC0hllmRP/u71EevEy3XybV4y9WqKmZedrwzMhO6yl2QmeiR3U26iYV/vdl+p/r/AvMhAk86cw6LgAAAABJRU5ErkJggg=='),
	('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAJHSURBVDjLfZJPa1NREMV/972ksYmx0bbUpzS1ValpKVQohgguRLuxIBRBcKMbwS/g2l026jfQpWtTcCEFN+Kii0AoSFNpQUirlFprXmybNi/v3nHxYv6Q6oFhLsydc+aeO+rWs8UX08nYkx7bigOIAGIQEcQImCCLMRgjFEuVt+9fzt+jgdC10fjT00PnAQukdbkra0H7PhcOardpQwgBRIEECjSUxAiiTaCsWyQ9Fqc6CB5dP8P4+DCfVnYZONVDtabb66SG4ywWfjCfcQBYWVEddUtEANjYOeTVYql5/hurm3vklrZY3dwj8EjofEIDNyb7AYhGbKIRm+RgL1++7bOxc8h8xuHnb4/joIrFoqRSKQCWl5epVCpEo1Fs2z62QUSoVqu1Uqn0oVAoPA8dbb9DTrwBI5TLs6TTaUKhEEop/gXP8yKO44waYx6HRPvQcL+vr49wOIy3vo4sLCC1GlYqhT19EWKrUPsKGKzIBM7Q7MTIyMhl++Gd/rM7h87M1i8bFbvCoFKobBZrdxe7XMZaW4OPS+iMjSVV0DVU/Tth26dcG7JVu6uFQkEmNjYglwtW0hgwhr25S8SvHoAyIBrEx05k+Lw9idVlkueB1uD7zYjnivh1C0w9CF0PyNu/sUkwNobSuqmO1uynz3HSPgDjNxp9IFi4rgnCU1N4yWRrAq2JztyEiANiAAO9w6iBue4JXNelrjXRbBY5OkI8DxWPE2zE3dbyKIXnebiu20mQz+cfGGNeJxKJmGVZ/A+u65LP5+//AbkTRxnEop0TAAAAAElFTkSuQmCC'),
	('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAIzSURBVDjLpVO7a1NRGP/dm9ubpGlMioGiLdFBHCyFtksHZ6tiQZAMEbqZwTGgkw7B3cmugoOL/0ATujadlIZchCwGWlERF5XbNOc+zsPvnNvUQmMWAx8f5+b8Ht/jWEop/M/POXvodDpvOOebcRw7lEHZRBRFOr+rVCoPxxJ4nlcgwOtisVhJp6cREghSwngjh7OzRezstKp0Ok/Q7XbvaHCpVJrP5XI4OPwGrS6lglSSiBQEkYVhOL4Eutwql8vmwFiAmMAfvX0ikKdxa/2uKWMsga7RdV34vp8oC4Ebi8tGXZ2o60b/04FmFgTSl/RAtHWv+4GyMOr6v0v37k92kPRKmcuaYHFp1aiPXKgJPbBHzIkDbZlIxEn9dgRf/UT6+wGezRxCvXqsxNMN/xzBKVj8bZwm2vq0gha7jedf1oCpLHBxgZTsqUe96gzFpiHQ1kbbqC2b8ckkz81lca1gwc24oPEAEcWx0Fd/2Zbztuo9+GEc6CmkUqmk7rMuIglOFfIhfWccKiTwkIPx2CmggCAILmgH79vtNgaDAfL5PDLZNG2gZYhiAvKQSjsmhwE1m+ngBAzJTEx7E2bsWq221u/3N5rN5v7e3i7SroWrVxZQLs9DDEmdaQIYIAJyEQmwIMBRNEAcxclbqNfr25S2G43Geq/Xe0mjXdJLJS6/AM9RbwIaJyP700TCpdlY3z4CCxmsSc955clnZSnznnDz967KOrC+Dp2wc104yh6mZJzlfwCf3q+o0qkR9wAAAABJRU5ErkJggg=='),
	('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAIvSURBVDjLjZPLaxNRFIeriP+AO7Gg7nRXqo1ogoKCK0Fbig8QuxKhPop04SYLNYqlKpEmQlDBRRcFFWlBqqJYLVpbq6ktaRo0aWmamUxmJpN5ZvKoP++9mmlqWuzAt7jc+X2Hcy6nDkAdhXxbCI2Epv+wlbDeyVUJGm3bzpVKpcVyuYyVIPcIBAL3qiXVgiYaNgwDpmk6qKoKRVEgCAKT8DyPYDDoSCrhdYHrO9qzkdOQvp+E+O04hC+tED63gBs+QiDnhQgTWJYFWiQUCv2RUEH/g4YNXwdcT/VEJ6xkF8zEDRixq1CnriD94SikH08gikJNS2wmVLDwybONH3GbNt8DY+YMrDk/tGkvhOFmKPE+pxVJkpDJZMBx3JJAHN+/MTPq8amxdtj8fWjhwzB+diH5ag9y8V6QubDhUYmmaWwesiwvCYRRtyv9ca9oc37kk3egTbbBiPowP+iGOHGT0A1h7BrS43ehiXHous5EjoCEx3IzF6FMnYMcPgs95iOCW1DDXqTfnEBqsBnRR9shTvYibyhsiBRHwL13dabe7r797uHOx3Kkm1T2IDfhhTRyAfMDh5Aauox8Ns5aKRQKDNrSsiHSZ6SHoq1i9nkDuNfHkHi2D9loHwtSisUig4ZXFaSG2pB8cZBUPY+ila0JV1Mj8F/a3DHbfwDq3Mtlb12R/EuNoKN10ylLmv612h6swKIj+CvZRQZk0ou1hMm/OtveKkE9laxhnSvQ1a//DV9axd5NSHlCAAAAAElFTkSuQmCC');

# 32 samples
INSERT INTO emergency_contact 
	(ec_name, ec_phone, ec_relationship, ec_notes)
VALUES
	('Wileen Ruvel', 			'7002774484', 	'Parent',	'patient has a restraining order on ex-husband'),
	('Omero Bims', 				'1619759184', 	'Partner',	'patient''s partner OMERO lives in a different state than patient'),
	('Barnabas Elverstone', 	'3202880819', 	'Spouse',	'listed phone num is cell; work phone = 5108417895'),
	('Bunny Oherlihy', 			'8429555430', 	'Partner',	'2nd emergency contact: brother John 2145263542'),
	('Louella Askey', 			'9561247781', 	'Partner',	NULL),
	('Yasmeen Barukh', 			'2169357463', 	'Parent',	NULL),
	('Tracie Wharby', 			'9371249842', 	'Spouse',	NULL),
	('Merci Richardon', 		'8812748490', 	'Guardian',	NULL),
	('Olivie Jeandillou', 		'4207360379', 	'Guardian',	NULL),
	('Shara Foggo', 			'8875621439', 	'Guardian',	NULL),
	('Nicol Jaime', 			'2403897031', 	'Parent',	NULL),
	('Cordey Stairs', 			'3054912491', 	'Guardian',	NULL),
	('Tami Springle', 			'9708109008', 	'Partner',	NULL),
	('Jasmine Frandsen', 		'6197525320', 	'Parent',	NULL),
	('Penn Reaveley', 			'1859893787', 	'Parent',	NULL),
	('Saxe Peachment', 			'2745913064', 	'Spouse',	NULL),
	('Nanete Ruter', 			'5201306475', 	'Partner',	NULL),
	('Neely Kertess', 			'5801402715', 	'Spouse',	NULL),
	('Kailey Mellsop', 			'4387012020', 	'Guardian',	NULL),
	('Weylin Blackbrough', 		'8683501090', 	'Guardian',	NULL),
	('Ax MacChaell', 			'1014148773', 	'Partner',	NULL),
	('Ame Claybourne', 			'3561894921', 	'Spouse',	NULL),
	('Manolo Bonhan', 			'5442121812', 	'Partner',	NULL),
	('Isac Twelftree', 			'9266651614', 	'Parent',	NULL),
	('Taryn Willarton', 		'6597468061', 	'Partner',	NULL),
	('Hamid D Alesio', 			'9015918159', 	'Spouse',	NULL),
	('Ingmar Falkingham', 		'2403552633', 	'Partner',	NULL),
	('Rowe Lysaght', 			'2822794839', 	'Partner',	NULL),
	('Grant Kraut', 			'3459280050', 	'Spouse',	NULL),
	('Harp Hitchens', 			'9923654271', 	'Guardian',	NULL),
    ('Cassey Cready',			'4191080085',	'Parent',	NULL),
    ('Cassey Cready',			'4191080085',	'Parent',	NULL);

# 8 samples
INSERT INTO insurer
		(insurer_id, insurer_name, insurer_phone)
VALUES  (1, 'Self pay',             '0000000000'),
        (2, 'Gold Shield',          '4191311184'),
        (3, 'Coop Group Health',    '2754092929'),
        (4, 'Medihelp',             '1833539227'),
        (5, 'Fightsong',            '8944140296'),
        (6, 'FitCare Health Plan',  '7438496231'),
        (7, 'Sigma',                '8161877508'),
        (8, 'Gold Cross',           '4761665265');

# 6 samples
	-- cost of appointments estimated
    -- source: https://www.bluecrossma.com/blue-iq/pdfs/TypicalCosts_89717_042709.pdf
    -- source: https://www.dignityhealth.org/articles/urgent-care-without-insurance-how-does-it-add-up
INSERT INTO appointment_type
		(appt_type_id, appt_type_description, appt_type_cost)
VALUES  (1, 'annual adult',   220.00),
        (2, 'focused adult',  155.00),
        (3, 'urgent adult',   180.00),
        (4, 'annual child',   180.00),
        (5, 'focused child',  135.00),
        (6, 'urgent child',   150.00);
        
# 15 samples    
    -- the ICD10 code is shortened to the first 3 chars for simplicity sake
    -- source: https://www.wellstar.org/about-us/icd-10/documents/top_diagnosis_codes_(crosswalks)/urgent%20care%20top%20diagnosis%20codes%20(crosswalk).pdf
    -- source: https://www.choa.org/~/media/files/Childrens/medical-professionals/physician-resources/icd10-toolkits/urgent-care.pdf?la=en
INSERT INTO diagnosis
		(dx_code, dx_name)
VALUES  ('Z00', 'Routine health maintenance'),
        ('401', 'Hypertension'),
        ('R69', 'Illness, unspecified'),
        ('J06', 'Acute upper respiratory infection'),
        ('T78', 'Allergy'),
        ('M54', 'Back pain'),
        ('L30', 'Dermatitis'),
        ('E13', 'Type 2 diabetes mellitus'),
        ('R05', 'Cough'),
        ('F90', 'A.D.H.D. unspecified'),
        ('M12', 'Arthritis'),
        ('H66', 'Acute otitis media'),
        ('R51', 'Headache'),
        ('H11', 'Conjunctival hyperemia'),
        ('F33', 'Depression');

# 27 samples
INSERT INTO appointment
    (appt_id, appt_date, appt_time, pt_id, dr_id, appt_type_id)
    # date = 'YYYY-MM-DD'
    # time = 'HH:MM'
VALUES
    (1,     '2019-03-01', '07:30', 1, 1, 1),	# dr vanderhoff, jareb kubecka, annual adult
    (2,     '2019-03-01', '08:00', 2, 1, 1),    # dr vanderhoff, delilah de malchar, annual adult
    (3,     '2019-03-01', '08:30', 3, 1, 1),    # dr vanderhoff, laurene butterick, annual adult
    (4,     '2019-03-01', '09:00', 4, 2, 1),    # dr boyland, laurene butterick, annual adult
    (5,     '2019-03-01', '09:20', 5, 2, 1),    # dr boyland, sherill klosa, annual adult
    (6,     '2019-03-01', '09:40', 6, 2, 1),    # dr boyland, pru tonsley, annual adult
    (7,     '2019-03-01', '10:00', 7, 2, 1),    # dr boyland, ferdinanda amies, annual adult
    (8,     '2019-03-01', '11:30', 8, 3, 2),    # dr petties, rubin brocklebank, focused adult
    (9,     '2019-03-01', '12:00', 9, 4, 2),    # dr wolverton, lucho louth, focused adult
    (10,	'2019-03-01', '15:00', 18, 5, 2),	# dr sauer, milissent woodgate, focused adult
    (11,    '2019-03-01', '15:30', 14, 5, 2),   # dr sauer, perle loughman, focused adult
    (12,    '2019-03-01', '16:00', 13, 5, 2),   # dr sauer, antonietta binnes, focused adult    
    (13,    '2019-03-01', '15:00', 15, 6, 1),	# dr roney, garvey o'codihie, annual adult
    (14,    '2019-03-01', '15:30', 16, 6, 1),	# dr roney, bartel cohen, annual adult
    (15,    '2019-03-01', '16:00', 17, 6, 1),  	# dr roney, onfroi broz, annual adult
    (16,    '2019-03-01', '17:45', 21, 7, 3),   # dr jacinto, madelin linney, urgent adult
    (17,    '2019-03-01', '18:15', 22, 7, 3),   # dr jacinto, jerrie surgener, urgent adult
    (18,    '2019-03-01', '18:45', 20, 7, 3),   # dr jacinto, derwin brouncker, urgent adult     
    (19,    '2019-03-01', '17:30', 24, 8, 3),   # dr curlee, lindsey bonn, urgent adult
    (20,    '2019-03-01', '18:00', 23, 8, 3),   # dr curlee, marita clifft, urgent adult
    (21,    '2019-03-01', '18:30', 30, 8, 3),   # dr curlee, cassey cready, urgent adult
    (22,    '2019-03-01', '07:30', 29, 9, 2),   # dr dicarlo, uri denson, focused adult
    (23,    '2019-03-01', '08:00', 27, 9, 2),   # dr dicarlo, fidela syde, focused adult
    (24,    '2019-03-01', '08:30', 25, 9, 2),   # dr dicarlo, quint ulyet, focused adult
    (25,    '2019-03-01', '07:30', 30, 10, 1),  # dr stockard, cassey cready, annual adult
    (26,    '2019-03-01', '08:00', 28, 10, 1),  # dr stockard, fenelia birden, annual adult
    (27,    '2019-03-01', '08:30', 26, 10, 1);  # dr stockard, sunny coppard, annual adult

# 10 patients, total 18 diagnoses
INSERT INTO diagnosis_list
	(dx_list_id, appt_id, dx_code)
VALUES
	(1,		1,	'T78'),
    (2,	 	1,	'R05'),
    (3,	 	1,	'H66'),
    (4,	 	2,	'F33'),
    (5, 	2,	'R51'),
    (6, 	3,  'R69'),
    (7, 	4,  'Z00'),
    (8, 	5,	'401'),
    (9, 	6,  'M54'),
    (10,	6,  'F90'),
    (11,	7,  'F90'),
    (12,	8,  'F90'),
    (13,	8,  'R51'),
    (14,	9,  'M12'),
    (15,	9,  'H11'),
    (16,	9,  '401'),
    (17,	10, '401'),
    (18,	10, 'E13');
    
# 32 samples
INSERT INTO pt_insurance
	(pt_insurance_id, insurer_id, pt_id)
VALUES
    ('419131118401JK', 2, 1),
    ('183353922702DD', 4, 2),
    ('743849623103LB', 6, 3),
    ('275409292904JA', 3, 4),
    ('743849623105SK', 6, 5),
    ('419131118406PT', 2, 6),
    ('419131118407FA', 2, 7),
    ('894414029608RB', 5, 8),
    ('476166526509LL', 8, 9),
    ('816187750810OS', 7, 10),
    ('816187750811LG', 7, 11),
    ('476166526512FB', 8, 12),
    ('816187750813AB', 7, 13),
    ('000000000014PL', 1, 14),
    ('183353922715GO', 4, 15),
    ('743849623116BC', 6, 16),
    ('275409292917OB', 3, 17),
    ('743849623118MW', 6, 18),
    ('419131118419ET', 2, 19),
    ('419131118420DB', 2, 20),
    ('894414029621ML', 5, 21),
    ('476166526522JS', 8, 22),
    ('816187750823MC', 7, 23),
    ('816187750824LB', 7, 24),
    ('000000000025QU', 1, 25),
    ('743849623126SC', 6, 26),
    ('419131118427FS', 2, 27),
    ('419131118428FB', 2, 28),
    ('894414029629UD', 5, 29),
    ('476166526530CC', 8, 30),
    ('476166526530C1', 8, 31),
    ('476166526530C2', 8, 32);

# 48 samples
INSERT INTO reimbursement_rate
VALUES
	(1, 1, 0.0),
	(1, 2, 0.0),
	(1, 3, 0.0),
	(1, 4, 0.0),
	(1, 5, 0.0),
	(1, 6, 0.0),
	(2, 1, 15.5),
	(2, 2, 75.0),
	(2, 3, 75.0),
	(2, 4, 75.0),
	(2, 5, 30.0),
	(2, 6, 75.0),
	(3, 1, 25.0),
	(3, 2, 80.0),
	(3, 3, 80.0),
	(3, 4, 80.0),
	(3, 5, 50.0),
	(3, 6, 80.0),
	(4, 1, 30.0),
	(4, 2, 90.0),
	(4, 3, 90.0),
	(4, 4, 90.0),
	(4, 5, 90.0),
	(4, 6, 90.0),
	(5, 1, 20.0),
	(5, 2, 80.0),
	(5, 3, 80.0),
	(5, 4, 80.0),
	(5, 5, 80.0),
	(5, 6, 80.0),
	(6, 1, 50.0),
	(6, 2, 50.0),
	(6, 3, 50.0),
	(6, 4, 50.0),
	(6, 5, 50.0),
	(6, 6, 50.0),
	(7, 1, 0.0),
	(7, 2, 75.0),
	(7, 3, 75.0),
	(7, 4, 75.0),
	(7, 5, 50.0),
	(7, 6, 75.0),
	(8, 1, 20.0),
	(8, 2, 75.0),
	(8, 3, 75.0),
	(8, 4, 75.0),
	(8, 5, 50.0),
	(8, 6, 75.0);

/*
	SAMPLE QUERIES AND VIEWS
*/

/*
	Query 1
    What is most common specialty at the practice?
    Create a list of doctor specialties and how many doctors practice that specialty.
    Order the list where the most common specialty is at the top.
*/
SELECT dr_specialty, COUNT(*)
FROM doctor
GROUP BY dr_specialty
ORDER BY COUNT(*) DESC;
    
/*
	Query 2
	Get a list of the names and pager numbers for urgent care doctors.
*/
SELECT dr_lname, dr_fname, dr_pager_num
FROM doctor
WHERE dr_specialty = 'urgent care'
ORDER BY dr_lname, dr_fname;

/* 
	Query 3
    Which doctor has seen the most patients (in all time)?
    Create a list of doctors and how many appointments they have associated with them.
    Order the list so that the doctor who has seen the most appointments is at the top.
*/
SELECT dr_id, dr_lname, dr_fname, COUNT(appt_type_id) AS 'Number of appointments'
FROM appointment
	JOIN appointment_type USING (appt_type_id)
    JOIN doctor USING (dr_id)
GROUP BY dr_id
ORDER BY COUNT(*) DESC;

/*
	Query 4
    List all patients who live in the Pacific Northwest
*/
SELECT  pt_id                           AS 'Patient ID',
        CONCAT(pt_fname, ' ', pt_lname) AS 'Patient'
FROM patient
WHERE pt_state IN ('OR', 'WA', 'ID', 'MT', 'AK', 'WY');

/*
	Query 5
	List all diagnoses coded and their frequency.
    Order results so that most frequently diagnosed conditions are at the top.
*/
SELECT  dx_name     AS 'Diagnosis',
        COUNT(*)    AS 'Total times coded in charts'
FROM diagnosis
	JOIN diagnosis_list USING (dx_code)
	JOIN appointment 	USING (appt_id)
GROUP BY dx_name
ORDER BY 2 DESC;

/*
    Query 6
    Generate a table that shows all adult appointment types, the insurer, the office charge, and
    the value paid by the insurer.
    Organize them by appointment description, then insurer name.
*/
SELECT  appt_type_description               				AS 'Appointment Type',
		insurer_name                        				AS 'Insurer',        
        appt_type_cost										AS 'Office''s Charge',
        ROUND(reimbursement_rate/100 * appt_type_cost, 2) 	AS 'Value paid by Insurer'
FROM insurer
    JOIN reimbursement_rate                 USING (insurer_id)
    JOIN appointment_type                   USING (appt_type_id)
WHERE appt_type_description LIKE '%adult%'
ORDER BY appt_type_description, insurer_name;

/*
	Query 7
    Generate a table that lists all unique insurers and the number of patients in the practice that
    have insurance from that company.
*/
SELECT  insurer_name        AS 'Insurance',
        COUNT(pt_id)        AS 'Patient Count'
FROM pt_insurance
	JOIN insurer USING (insurer_id)
GROUP BY insurer_name WITH ROLLUP;

/*
	Query 8
    Generate a table that shows ALL the different appointment
    types and how many of those appointments this office has on record.
    Also get the total number of appointments this office has on record.
*/
SELECT  appt_type_description   AS 'appointment type',
		COUNT(*)                AS 'total on record'
FROM appointment
    RIGHT OUTER JOIN appointment_type USING (appt_type_id)
GROUP BY appt_type_description WITH ROLLUP;

/*
	(Sample View 1)
    Get a list of appointments for a given day.
    Example use case: printing a copy of the schedule to see a day's visits 'at-a-glance'.
    You can replace the date in the WHERE clause for other days, or even use 'CURDATE()' for current date.
    You could also use in the WHERE clause 'CURDATE() - 1' for yesterday's appointment list.
    It's helpful to know the dr's name, the pt's name, and the appointment time, and appointment type.
    It should list the appointments by dr, then by time.
*/
CREATE OR REPLACE VIEW appt_list_by_day
AS
	SELECT 	CONCAT(dr_lname, ', ', dr_fname)	AS Doctor,
			TIME_FORMAT(appt_time, '%h:%i %p')	AS `Time`,
            appt_type_description 			 	AS Appointment,
            CONCAT(pt_lname, ', ', pt_fname)	AS Patient
	FROM appointment
		JOIN patient 			USING (pt_id)
        JOIN doctor 			USING (dr_id)
        JOIN appointment_type 	USING (appt_type_id)
	WHERE appt_date = '2019-03-01'
	ORDER BY Doctor ASC, `Time` ASC;

SELECT * FROM appt_list_by_day;

/*
	(Sample View 2)
    Create a list of emergency contacts for all patients.
    It's helpful to know the patient's name, emergency contact name and phone number.
    It should list the emergency contacts by patient's name.
*/
CREATE OR REPLACE VIEW emergency_contact_by_patient
AS
	SELECT 	CONCAT(pt_lname, ', ', pt_fname)	AS Patient,
			ec_name								AS `Emergency Contact`,
			ec_phone							AS `Emergency Contact Phone`
	FROM patient
		JOIN emergency_contact 	USING (pt_id)
	ORDER BY Patient ASC;

SELECT * FROM emergency_contact_by_patient;

/*
	(Sample View 3)
    Get a list of all patients who are under the age of 18.
    Show their phone number and mailing addresses.
    Example use case: Send annual physical reminder to patients' parents.
*/
CREATE OR REPLACE VIEW UnderagePatients
AS
    SELECT  CONCAT(pt_fname, ' ', pt_lname) AS Name,
            pt_birthday, pt_phone, pt_address, pt_city, pt_state, pt_zip
    FROM patient
    WHERE TIMESTAMPDIFF(YEAR, pt_birthday, CURDATE()) < 18 ;
    
SELECT * FROM UnderagePatients;


