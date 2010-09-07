module mgn.gfx.utils.ObjectReader;

import std.array;
import std.conv;
import std.container;
import std.stdio;
import std.string;
import std.stream;

class ObjectReader {
    string          filename; // the name of the object file
    std.stream.File file;     // the object file
    uint    cc, // comment count
            vc, // vertex count
            tc, // texture coordinate count
            nc, // normal vector count
            fc, // face count
            mtllibc; // material lib count

  public:
    // initialize parser with filename
    this(string filename) {
        this.filename = filename;
        file = new std.stream.File();
    }

    // destructor
    ~this()    {
        if(file.isOpen())
            file.close();
    }

    // open file, return true if successful
    bool open() {
        try {
            file = new std.stream.File(filename, FileMode.In);
            cc=0;
            vc=0;
            tc=0;
            nc=0;
            fc=0;
            mtllibc = 0;
            return true;
        } catch(OpenException e) { //Catches the exception if the file was not there.
            writefln("[Error] Could not open file: " ~ filename);
            return false;
        }
    }

    //close file
    void close() {
        if(file.isOpen())
            file.close();
    }

    //read data from file
    void read() {
        if(file.isOpen())
        {
            char[] line;
            while(true)
            {
                if( file.eof() )
                    break;

                line = file.readLine();
                parse_line(line);
            }
        }
    }

    void parse_line(char[] line) {
        int index;
        int not_found = -1;

        //search comment
        index = indexOf(line, "#");
        if(index != not_found) {
            cc++;
            process_comment(cc, line[index+1 .. $]);
            return;
        }

        index = indexOf(line, "$");
        if(index != not_found) {
            return;
        }

        index = indexOf(line, "mtllib");
        if(index != not_found) {
            ++mtllibc;
            process_mtllib(index, line[index+6 .. $]);
            return;
        }

        index = indexOf(line, "usemtl");
        if(index != not_found) {
            process_usemtl(fc, line[index+6 .. $]);
            return;
        }

        index = indexOf(line, "bmat");
        if(index != not_found) {
            return;
        }

        index = indexOf(line, "step");
        if(index != not_found) {
            return;
        }

        index = indexOf(line, "curv2");
        if(index != not_found) {
            return;
        }

        index = indexOf(line, "curv");
        if(index != not_found) {
            return;
        }

        index = indexOf(line, "surf");
        if(index != not_found) {
            return;
        }

        index = indexOf(line, "parm");
        if(index != not_found) {
            return;
        }

        index = indexOf(line, "trim");
        if(index != not_found) {
            return;
        }

        index = indexOf(line, "hole");
        if(index != not_found) {
            return;
        }

        index = indexOf(line, "scrv");
        if(index != not_found) {
            return;
        }

        index = indexOf(line, "end");
        if(index != not_found) {
            return;
        }

        index = indexOf(line, "con");
        if(index != not_found) {
            return;
        }

        index = indexOf(line, "deg");
        if(index != not_found) {
            return;
        }

        index = indexOf(line, "sp");
        if(index != not_found) {
            return;
        }

        index = indexOf(line, "vp");
        if(index != not_found) {
            return;
        }

        //search texcoord
        index = indexOf(line, "vt");
        if(index != not_found) {
            tc++;
            float u,v,w = 0.0;
            char[][] tex_coords = split( line[index+2 .. $] ); // split on whitespaces
            if (tex_coords.length > 0)
                u = to!float(tex_coords[0]);
            if (tex_coords.length > 1)
                v = to!float(tex_coords[1]);
            if (tex_coords.length > 2)
                w = to!float(tex_coords[2]);

            process_texcoord(tc,u,v,w);
            return;
        }

        //search normal
        index = indexOf(line, "vn ");
        if(index != not_found) {
            nc++;
            float x,y,z = 0;
            char[][] normal_coords = split( line[index+2 .. $] );
            if (normal_coords.length > 0)
                x = to!float(normal_coords[0]);
            if (normal_coords.length > 1)
                y = to!float(normal_coords[1]);
            if (normal_coords.length > 2)
                z = to!float(normal_coords[2]);

            process_normal(nc,x,y,z);
            return;
        }

        index = indexOf(line, "mg ");
        if(index != not_found) {
            return;
        }
        index = indexOf(line, "g ");
        if(index != not_found) {
            //group
            return;
        }

        index = indexOf(line, "o ");
        if(index != not_found) {
            //object name
            return;
        }

        index = indexOf(line, "s ");
        if(index != not_found) {
            //smoothing group
            return;
        }

        index = indexOf(line, "p ");
        if(index != not_found) {
            //point
            return;
        }

        index = indexOf(line, "l ");
        if(index != not_found) {
            //line
            return;
        }

        //search vertex
        index = indexOf(line, "v ");
        if(index != not_found) {
            vc++;
            float x = 0.0, y = 0.0, z = 0.0;
            char[][] vertexCoords = split( line[index+2 .. $] );
            if (vertexCoords.length > 0)
                x = to!float(vertexCoords[0]);
            if (vertexCoords.length > 1)
                y = to!float(vertexCoords[1]);
            if (vertexCoords.length > 2)
                z = to!float(vertexCoords[2]);

            process_vertex(vc,x,y,z);
            return;
        }

        //search face
        index = indexOf(line, "f ");
        if(index != not_found) {
            line = line[index+1 .. $];
            fc++;

            int vi,ti,ni;

            int slash;
            while(true) {
                slash = indexOf(line, " /");
                if(slash != not_found)
                    line = line[0 .. slash] ~ line[slash+1 .. $];
                else
                    break;
            }
            while(true) {
                slash = indexOf(line, "/ ");
                if(slash != not_found)
                    line = line[0 .. slash+1] ~ line[slash+2 .. $];
                else
                    break;
            }

            auto vIndices = appender!(int[])();
            auto tIndices = appender!(int[])();
            auto nIndices = appender!(int[])();

            char[][] vertexCoords = split( line[index+2 .. $] );
            foreach(char[] coord; vertexCoords) {
                vi = parse!(int)(coord);
                vIndices.put( vi );
                if (coord[0] == '/') {
                    coord = coord[1 ..$];
                    if (coord[0] == '/') {
                        coord = coord[1 ..$];
                        ni = parse!(int)( coord );
                        nIndices.put( ni );
                    } else {
                        ti = parse!(int)( coord );
                        tIndices.put( ti );
                        if (coord[0] == '/') {
                            coord = coord[1 ..$];
                            ni = parse!(int)( coord );
                            nIndices.put( ni );
                        }
                    }
                }
            }

            int[] vArray = null, tArray = null, nArray = null;

            if( !(vIndices.data().empty()) )
                vArray = vIndices.data();


            if( !(tIndices.data().empty()) )
                tArray = tIndices.data();


            if( !(nIndices.data().empty()) )
                nArray = nIndices.data();

            process_face(fc, vIndices.data().length, vArray, tArray, nArray);

            return;
        }
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
