/*PGR-GNU*****************************************************************

Copyright (c) 2022 pgRouting developers
Mail: project@pgrouting.org

Copyright (c) 2022 Nitish Chauhan
Mail: nitishchauhan0022 at gmail.com

------

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

 ********************************************************************PGR-GNU*/
#include <iostream>
#include <iterator>
#include <vector>
#include <deque>

#include <boost/graph/adjacency_list.hpp>
#include <boost/graph/graph_traits.hpp>
#include <boost/graph/hawick_circuits.hpp>
#include <boost/property_map/property_map.hpp>


struct circuit {
    int id;
    u_int64_t seq;
};


template <class V>
class circuit_detector {
 public:
    explicit circuit_detector(std::vector<V> &data) : m_data(data) {}
    template <typename Path, typename Graph>
    void cycle(Path const &p, Graph const &g) {
        counter++;
        if (p.empty())
            return;

        typedef typename boost::property_map<Graph,
                boost::vertex_index_t>::const_type IndexMap;
        IndexMap indices = get(boost::vertex_index, g);

        typename Path::const_iterator i, before_end = boost::prior(p.end());
        for (i = p.begin(); i != before_end; ++i) {
            auto vertex = get(indices, *i);
            m_data.push_back({counter, vertex});
        }
        auto vertex = get(indices, *i);
        m_data.push_back({counter, vertex});
    }
 private:
    std::vector<V> &m_data;
    int counter = 0;
};

int main() {
    typedef boost::adjacency_list<boost::vecS, boost::vecS,
            boost::bidirectionalS> Graph;
    typedef std::pair<std::size_t, std::size_t> Pair;
    Pair edges[11] = {Pair(1, 2),
                      Pair(1, 5),
                      Pair(2, 3),
                      Pair(2, 7),
                      Pair(3, 1),
                      Pair(3, 2),
                      Pair(3, 4),
                      Pair(3, 6),
                      Pair(4, 5),
                      Pair(5, 2),
                      Pair(6, 4)};

    Graph G(7);

    for (size_t i = 0; i < sizeof(edges) / sizeof(edges[0]); i++)
        boost::add_edge(edges[i].first, edges[i].second, G).first;

    std::vector<circuit> result;
    circuit_detector <circuit> detector(result);
    boost::hawick_circuits(G, detector);

    for (int i = 0; i < result.size(); i++) {
    std::cout << result[i].id << " " << result[i].seq << std::endl;
    }
}
