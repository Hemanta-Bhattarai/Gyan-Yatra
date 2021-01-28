
#include <iostream>
#include <vector>
using namespace std;

enum class Color{red, green, blue};
enum class Size{small,medium, large};

struct Product{
    string name;
    Color color;
    Size size;
};


struct ProductFilter
{
    vector<Product*> by_color (vector<Product*> items, Color color){
        vector<Product*> results;
        for(auto& i : items){
            if(i->color == color)
                results.push_back(i);
        }
        return results;
    }

    vector<Product*> by_size (vector<Product*> items, Size size){
        vector<Product*> results;
        for(auto& i : items){
            if(i->size == size)
                results.push_back(i);
        }
        return results;
    }
};


//better filter Enterprise pattern


template <typename T> struct AndSpecification;

template<typename T> struct Specification{
    virtual bool is_satisfied(T* item) = 0;
    AndSpecification<T> operator&&(Specification<T>& other){
        return AndSpecification<T>(*this, other);
    }
};

template<typename T> struct Filter{
    virtual vector<T*> filter(vector<T*> items, Specification<T>& sepc) = 0;
};

struct BetterFilter: Filter<Product>{
    vector<Product*> filter(vector<Product*> items, Specification<Product>& spec) override
    {
        vector<Product*> result;
        for(auto& item : items)
            if(spec.is_satisfied(item))
                result.push_back(item);
        return result;
    }
};


struct ColorSpecification : Specification<Product>
{
    Color color;
    explicit ColorSpecification(const Color color):color(color){}
    bool is_satisfied(Product* item) override{
        return item->color == color;
    }
};

struct SizeSpecification : Specification<Product>
{
    Size size;
    explicit SizeSpecification(const Size size):size(size){}
    bool is_satisfied(Product* item) override{
        return item->size == size;
    }
};

template<typename T>
struct AndSpecification:Specification<T>{
    Specification<T>& first;
    Specification<T>& second;
    AndSpecification(Specification<T> &first, Specification<T>& second):first(first), second(second){}
    bool is_satisfied(T *item) override{
        return first.is_satisfied(item) && second.is_satisfied(item);
    }



};



int main() {
    Product apple{"apple",Color::green,Size::small};
    Product tree{"tree",Color::green,Size::large};
    Product house{"house",Color::blue,Size::small};
    Product tower{"tower",Color::red,Size::large};
    Product train{"train",Color::blue,Size::large};

    vector<Product*> items{&apple, &tree, &house, &tower, &train};

    ProductFilter pf;
    auto green_things = pf.by_color(items,Color::green);
    for(auto& item:green_things)
        cout<<item->name<<" is green"<<endl;

    auto large_things = pf.by_size(items, Size::large);
    for(auto& item:large_things)
        cout<<item->name<<" is large"<<endl;

   BetterFilter bf;
   ColorSpecification green(Color::green);
   for(auto& item : bf.filter(items, green) )
       cout<<item->name<<" is green"<<endl;


   SizeSpecification large(Size::large);
   AndSpecification<Product> green_and_large(green, large);

    for(auto& item : bf.filter(items, green_and_large) )
        cout<<item->name<<" is green and large"<<endl;

    auto green_large = green && large;
    for(auto& item : bf.filter(items, green_large) )
        cout<<item->name<<" is green and large"<<endl;




    return 0;
}
