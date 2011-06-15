%module kytea
%include "std_string.i"
%include "std_vector.i"
%include "std_pair.i"
%{
#define SWIG_FILE_WITH_INIT
#include "kytea/kytea.h"
#include "kytea/kytea-struct.h"
%}
%rename(Word) KyteaWord;
%rename(Sentence) KyteaSentence;
%rename(String) KyteaString;
%rename(Config) KyteaConfig;

%typemap(in) char ** {
    /* Check if is a list */
    if (PyList_Check($input)) {
        int size = PyList_Size($input);
        int i = 0;
        $1 = (char **) malloc((size+1)*sizeof(char *));
        for (i = 0; i < size; i++) {
            PyObject *o = PyList_GetItem($input,i);
            if (PyString_Check(o))
                $1[i] = PyString_AsString(PyList_GetItem($input,i));
            else {
                PyErr_SetString(PyExc_TypeError,"list must contain strings");
                free($1);
                return NULL;
            }
        }
        $1[i] = 0;
    } else {
        PyErr_SetString(PyExc_TypeError,"not a list");
        return NULL;
    }
}

%typemap(freearg) char ** {
    free((char *) $1);
}

namespace kytea  {
    class KyteaString {
    public:
        ~KyteaString();
    };

    class KyteaWord {
    public:
        KyteaWord(const KyteaString & s);
        KyteaString surf;
        std::vector< std::vector< std::pair<KyteaString,double> > > tags;
        bool isCertain;
        bool unknown;
    };

    class StringUtil {
    public:
        virtual KyteaString mapString(const std::string & str) = 0;
        std::string showString(const KyteaString & c);
        const char* getEncodingString();
        ~KyteaString();
    };


    class KyteaSentence {
    public:
        typedef std::vector<KyteaWord> Words;
        typedef std::vector<double> Floats;
        KyteaString chars;
        Floats wsConfs;
        Words words;

        KyteaSentence();
        KyteaSentence(const KyteaString & str);
        ~KyteaSentence() {};
    };

    class KyteaConfig {
    public:
        KyteaConfig();
        ~KyteaConfig();
        void parseTrainCommandLine(int argc, char ** argv);
        void parseRunCommandLine(int argc, char ** argv);
        void printUsage();
        void printVersion();
        const std::vector<std::string> & getDictionaryFiles() const;
        const std::vector<std::string> & getSubwordDictFiles() const;
        const std::string & getModelFile() const;
        const char getModelFormat() const;
        const unsigned getDebug() const;
        const StringUtil * getStringUtil() const;

        const char getCharN() const;
        const char getCharWindow() const;
        const char getTypeN() const;
        const char getTypeWindow() const;
        const char getDictionaryN() const;
        const char getUnkN() const;
        const unsigned getTagMax() const;
        const unsigned getUnkBeam() const;
        const std::string & getUnkTag() const;
        const std::string & getDefaultTag() const;

        const double getBias() const;
        const double getEpsilon() const;
        const double getCost() const;
        const int getSolverType() const;
        const bool getDoWS() const;
        const bool getDoTags() const;
        const bool getDoTag(int i) const;
        const char* getWordBound() const;
        const char* getTagBound() const;
        const char* getElemBound() const;
        const char* getUnkBound() const;
        const char* getNoBound() const;
        const char* getHasBound() const;
        const char* getSkipBound() const;
        const char* getEscape() const;

        const double getConfidence() const;
        const char getEncoding() const;
        const char* getEncodingString() const;
        int getNumTags() const;
        bool getGlobal(int i) const;

        const std::vector<std::string> & getArguments() const;

        void setDebug(unsigned debug);
        void setModelFile(const char* file);
        void setModelFormat(char mf);
        void setEpsilon(double v);
        void setCost(double v);
        void setBias(bool v);
        void setSolverType(int v);
        void setCharWindow(char v);
        void setCharN(char v);
        void setTypeWindow(char v);
        void setTypeN(char v);
        void setDictionaryN(char v);
        void setUnkN(char v);
        void setTagMax(unsigned v);
        void setUnkBeam(unsigned v);
        void setUnkTag(const std::string & v);
        void setUnkTag(const char* v);
        void setDefaultTag(const std::string & v);
        void setDefaultTag(const char* v);
        void setOnTraining(bool v);
        void setDoWS(bool v);
        void setDoTags(bool v);
        void setDoTag(int i, bool v) ;
        void setWordBound(const char* v);
        void setTagBound(const char* v);
        void setElemBound(const char* v);
        void setUnkBound(const char* v);
        void setNoBound(const char* v);
        void setHasBound(const char* v);
        void setSkipBound(const char* v);
        void setEscape(const char* v);
        void setNumTags(int v);
        void setGlobal(int v);
        void setEncoding(const char* str);
    };

    class Kytea {
    public:
        void readModel(const char* fileName);
        void writeModel(const char* fileName);

        void calculateWS(KyteaSentence & sent);
        void calculateTags(KyteaSentence & sent, int lev);
        void calculateUnknownTag(KyteaWord & str, int lev);

        StringUtil* getStringUtil();
        void analyze();

        Kytea();
        Kytea(KyteaConfig & config);
        ~Kytea();
    };
}

%ignore std::vector<kytea::KyteaWord>::vector(size_type);
%ignore std::vector<kytea::KyteaWord>::resize(size_type);
%template(Words) std::vector<kytea::KyteaWord>;
%template(Floats) std::vector<double>;
%template(KyteaTag) std::pair<kytea::KyteaString, double>;
%template(KyteaTagVector) std::vector<std::pair<kytea::KyteaString, double> >;
%template(Tags) std::vector< std::vector<std::pair<kytea::KyteaString, double> > >;
%template(StringVector) std::vector<std::string>;
