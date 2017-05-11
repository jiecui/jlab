% need a new drug
% First step is to convert a project file to a trial-per-file plus master header file
% Features:
%   [ ] Should be able to re-calculate the arm and any other "derived" per-sample data individually
%   [ ] Query Support: Given patient, session, trial number, data tag 'Supin/Pron', return array
%   [ ] Query Support: 
%   [ ] Should not be necessary that your session be labeled 'Pre', or other RWT-specific stuff
%   [ ] RWT-specific items like targets, delays, arm-calculating logic, should be isolated
%   [ ] Should a trial be an object? (see below)



% Experiment, Session, and Trial Objects
%
%  Objects have data and methods. Data of trial is going to be in an array or struct of arrays that resides on disk.
%   The data portion will be a disk file, and the run-time state of a trial will be 'loaded' or 'not loaded'. Only
%   the per-sample data will be in this disk file. Other meta-data will be in the actual class. A "factory" could
%   take the scene name and data and auto-produce the class instance -- different Trial sub-classes would produce
%   their arm data and targets differently, as well as the orientation data that could be cached here for pickup by
%   the crunching. Main benefit would be encapsulation and organization of all the code. You can also overload subscripting
%   operations. Let's think: 'trials(3)', is that 3rd elem of array of trials? "trial(3)", is that the 3rd sample,
%   and returns a TrialSample object? Big benefit could be that slicing and multi-dim operations could work on these
%   things... How DO we want to get to the different elems, as in Query Support above? I think they could be different
%   struct fields. Some overhead, but explicit! Easy. Decided.

%  Containers: Sessions contain objects. These may have fields that show their place in the RWT scheme. Perhaps they 
%   have the info about ignored trials. When you load a Session, does it automatically load all the Trials? Then you
%   can query on the comment and ignored status residing in the Trial. Trials will be lightweight. Session subsref could
%   return the trial info, such as scene names: "sess.scenename(1:5)" -- don't know how this is going to work. Has a
%   lot to do with how I want to access the data. I would rather keep it simple...

%  Containers: Experiments contain sessions. Experiments have attributes like Results? Perhaps at this level we have
%   dispensed with the lower-level sessions and trials, and what we have are "cached_results"-like arrays that are
%   well-labeled. The labelling then allows the retrieval of all the session and therefore sample-level data for each
%   trial. A nice extension would be to have a list of the sample-level data pieces that were used to get the "measures".

% Real Goals
%
%  We need papers! Therefore, this architectural project should have some relatively immediate pay-off to justify the
%   investment. Having a fast cross-patient trial database with plotting will allow us to quickly compare the sample-level
%   data across patients and time. Currently, the process is pretty slow. Also, we need to get to analyzing the training
%   session data quickly! This is a highly ranked priority, since being able to run stats on the training data could really
%   be good. Another goal is to "parse" individual trials. This will allow splitting some trials into different "phases"
%   that can then be analyzed in groups. I would like to pursue my phase-portrait scoring idea. We could also try to develop
%   a discriminant-function based approach that could perhaps show progression towards normality during training?
%
%   In sum, the single-trial storage and revamped plotting will help look at training data. It won't help new measures
%   such as discriminant and phase-based, but it will help get to that point. Object features are difficult to justify,
%   except that it could look good on resume, and as sample code. IF I just wanted to revamp the storage and plotting
%   without the OOP and just using as much of the current stuff as possible, would that be feasible? For now, the crunch
%   could all work the same (is there a reason to drastically change it??!?!), but my new stuff would split all the proj
%   files up into indiv. files, and new plotting functions would work on this data.
%
%   Drawbacks of design:
%   [ ] Many files! Therefore a management headache when transporting
%   [ ] Lots of rewriting if do the class thing
%

% Decisions
%
%  I think classes are over the top for this. Since there is not much of a syntax dividend, might as well use structs.
%
%  Therefore, I will proceed with a design document that really spells out how this will look and work!
%

% Design Proposal
%
% Scope
%  The proposed crunch additions will enable indexing of all the raw data for plotting, initially, but for all statistics
%  later. Initially, we will write the functionality to to build the indexing structure from an existing set of projects.

%
% backup works, reinstall video drivers

% brain fart -- what to do about bad sensor 2 trials, re the good measures
% construct, by hand, the binary matrix of cond x slice for each subject.
% convolve that with the measure_depends_on_sensor_2 matrix, and have that
% get consulted during crunch plotting. If true, put an asterisk somewhere?
% 
