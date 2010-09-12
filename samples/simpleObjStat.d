module mgn.gfx.samples;

import std.conv;
import std.stdio;
import mgn.gfx.utils.ObjectStatisticsReader;

int main( string[] args ) {
    if (args.length == 1) {
        writefln("Please pass an object file as parameter.");
        return 1;
    }

    // load object file
    string filename = args[1];
    ObjectStatisticsReader!double or  = new ObjectStatisticsReader!double( filename );
    if ( or.open() ) {
        or.read();
        // print statistics if opening was possible
        writefln("The file " ~ filename ~ " has been opened successfully!");
        writefln("Some statistics:");
        writefln( "\tNumber of comments: " ~ to!(string)(or.commentCount) );
        writefln( "\tNumber of vertices: " ~ to!(string)(or.vertexCount) );
        writefln( "\tNumber of texture coordinates: " ~ to!(string)(or.textureCoordCount) );
        writefln( "\tNumber of normal vectors: " ~ to!(string)(or.normalVectorCount) );
        writefln( "\tNumber of material lib references: " ~ to!(string)(or.materialLibCount) );
    }

    return 0;
}
