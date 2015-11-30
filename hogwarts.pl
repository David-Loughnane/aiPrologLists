/* the students in Hogwarts */
student(hp, 'Harry James Potter', gryffindor).
student(hg, 'Hermione Jean Granger', gryffindor).
student(rw, 'Ronald Weasley', gryffindor).
student(ll, 'Luna Lovegood', ravenclaw).
student(cc, 'Cho Chang', ravenclaw).
student(tb, 'Terry Boot', ravenclaw).
student(ha, 'Hannah Abbott', hufflepuff).
student(cd, 'Cedric Diggory', hufflepuff).
student(nt, 'Nymphadora Tonks',hufflepuff).
student(dm, 'Draco Malfoy', slytherin).
student(gg, 'Gregory Goyle', slytherin).
student(vc, 'Vincent Crabbe', slytherin).
student(dl, 'David Loughnane', gryffindor).

/* the teachers in Hogwarts */
teacher(ad, 'Albus Percival Wulfric Brian Dumbledore').
teacher(ff, 'Filius Flitwick').
teacher(rh, 'Rubeus Hagrid').
teacher(gl, 'Gilderoy Lockhart').
teacher(rl, 'Remus John Lupin').
teacher(mm, 'Minerva McGonagall').
teacher(qq, 'Quirinus Quirrell').
teacher(ss, 'Severus Snape').
teacher(ps, 'Pomona Sprout').
teacher(st, 'Sibyll Patricia Trelawney').
teacher(mh, 'Madam Hooch').
teacher(as, 'Aurora Sinistra').
teacher(cub, 'Cuthbert Binns').
teacher(bb, 'Bathsheba Babbling').
teacher(sv, 'Septima Vector').
teacher(chb, 'Charity Burbage').
teacher(wt, 'Wilkie Twycross').

/* compulsory courses for the MSc in Magic */
compCourse(astro, 'Astronomy', as).
compCourse(charms, 'Charms', ff).
compCourse(defence, 'Defence against the Dark Arts', qq).
compCourse(fly, 'Flying', mh).
compCourse(herb, 'Herbology', ps).
compCourse(history, 'History of Magic', cub).
compCourse(potions, 'Potions', ss).
compCourse(trans, 'Transfiguration', mm).

/* optional courses for the MSc in Magic */
optCourse(runes, 'Study of Ancient Runes', bb).
optCourse(arith, 'Arithmancy', sv).
optCourse(muggle, 'Muggle Studies', chb).
optCourse(creatures, 'Care of Magical Creatures', rh).
optCourse(div, 'Divination', st).
optCourse(app, 'Apparition', wt).
optCourse(choir, 'Frog Choir', ff).
optCourse(quid, 'Quidditch', mh).

/* Q2 optional courses taken by students */
enrolled_opt(cc,quid).
enrolled_opt(cc,arith).
enrolled_opt(cc,runes).
enrolled_opt(cd,creatures).
enrolled_opt(cd,muggle).
enrolled_opt(cd,runes).
enrolled_opt(dl,creatures).
enrolled_opt(dl,muggle).
enrolled_opt(dl,runes).
enrolled_opt(dm,creatures).
enrolled_opt(dm,muggle).
enrolled_opt(dm,runes).
enrolled_opt(gg,creatures).
enrolled_opt(gg,muggle).
enrolled_opt(gg,runes).
enrolled_opt(ha,creatures).
enrolled_opt(ha,arith).
enrolled_opt(ha,runes).
enrolled_opt(hg,muggle).
enrolled_opt(hg,arith).
enrolled_opt(hg,div).
enrolled_opt(hg,creatures).
enrolled_opt(hg,app).
enrolled_opt(hg,runes).
enrolled_opt(hp,quid).
enrolled_opt(hp,arith).
enrolled_opt(hp,div).
enrolled_opt(ll,quid).
enrolled_opt(ll,arith).
enrolled_opt(ll,div).
enrolled_opt(nt,creatures).
enrolled_opt(nt,muggle).
enrolled_opt(nt,runes).
enrolled_opt(rw,quid).
enrolled_opt(rw,arith).
enrolled_opt(rw,div).
enrolled_opt(tb,quid).
enrolled_opt(tb,arith).
enrolled_opt(tb,runes).
enrolled_opt(vc,creatures).
enrolled_opt(vc,muggle).
enrolled_opt(vc,runes).


/* Q3 what student is enrolled in what courses */
enrolled(SID,SCN) :-
    compCourse(SCN,_,_); enrolled_opt(SID,SCN).


/* Q4 what teacher teaches what courses */
teaches(TN,SCN) :-
    teacher(TID,TN),
    (compCourse(SCN,_,TID);
     optCourse(SCN,_,TID)).


/* Q5 what student is taught by what teacher */
taughtBy(SN,TN) :-
    student(SID,SN,_),
    enrolled(SID,SCN),
    teaches(TN,SCN).


/* Q6 optional course student enrolled in */
takesOption(SN,CN) :-
    student(SID,SN,_),
    enrolled_opt(SID,SCN),
    optCourse(SCN,CN,_).

	
/* Q7 list of all optional courses student enrolled in */
takesAllOptions(SN,OptCourses) :-
    setof(CN,takesOption(SN,CN),OptCourses).


/* Q8 lists all students in each house */ 
studentsInHouse(House,Students) :-
    setof([SID,SN],student(SID,SN,House),L),
    findall(SN,member([_,SN],L),Students).


/* Q9 list of all students on course by house */

/* helper - students, by house that are register to take course*/
enrolled_student(SN,SCN,House) :-
    student(SID,SN,House),
    (compCourse(SCN,_,_); enrolled_opt(SID,SCN)).
    
/* helper - generate list of students enrolled in course */
enrolledStudentsInHouse(SCN,House,EnrolledStudents):-
    findall(SN,enrolled_student(SN,SCN,House),EnrolledStudents).

studentsOnCourse(SCN,CN,StudentsByHouse) :-
    findall(House-EnrolledStudents,enrolledStudentsInHouse(SCN,House,EnrolledStudents),StudentsByHouse),
    (compCourse(SCN,CN,_) ; optCourse(SCN,CN,_)).


/* Q10 two students who share same option course */
sharedCourse(SN1,SN2,CN) :-
    takesOption(SN1,CN),
    takesOption(SN2,CN),
    SN1 \= SN2.


/* Q11 two students who share 3 optional courses */
sameOptions(SN1, SN2, Courses) :-
    setof(CN,sharedCourse(SN1,SN2,CN),Courses),
    length(Courses,3).

