module mgn.gfx.utils.ObjectStatisticsReader;

import std.array;
import std.conv;
import std.container;
import std.stdio;
import std.string;
import std.stream;
import mgn.gfx.utils.ObjectReader;

class ObjectStatisticsReader : ObjectReader  {

  public:
    // initialize parser with filename
    this(string filename) {
        super( filename );
    }

    // destructor
    ~this() {
    }

    // open file, return true if successful
    bool open() {
        if ( !super.open() ) {
            return false;
        }

        // reset all other memers to default

        return true;
    }

    int commentCount() {
        return cc;
    }

    int vertexCount() {
        return vc;
    }

    int textureCoordCount() {
        return tc;
    }

    int normalVectorCount() {
        return nc;
    }

    int materialLibCount() {
        return mtllibc;
    }

    //overide this function to process a comment
    void process_comment(int index, char[] comment) {

    }

    //overide this function to process a material lib declaration
    //the index is the face index from which on the material should be valid
    void process_mtllib(int index, char[] lib) {

    }

    //overide this function to process a comment
    void process_usemtl(int index, char[] mtl) {

    }

    //overide this function to process a vertex
    void process_vertex(int index, float x, float y, float z) {

    }

    //overide this function to process a texcoord
    void process_texcoord(int index, float u, float v, float w=0) {

    }

    //overide this function to process a normal
    void process_normal(int index, float x, float y, float z) {

    }

    //overide this function to process a face
    void process_face(int index, int vcount, int[] vertices, int[] texcoords = null, int[] normals = null) {

    }
}
